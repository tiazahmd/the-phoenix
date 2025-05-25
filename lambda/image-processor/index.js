const AWS = require('aws-sdk');
const sharp = require('sharp');
const s3 = new AWS.S3();
const sns = new AWS.SNS();

const SUPPORTED_FORMATS = ['jpg', 'jpeg', 'png', 'webp'];
const SIZES = [
    { width: 100, height: 100, suffix: 'thumbnail' },
    { width: 800, height: null, suffix: 'medium' },
    { width: 1200, height: null, suffix: 'large' }
];

exports.handler = async (event) => {
    console.log('Processing event:', JSON.stringify(event, null, 2));
    
    try {
        const bucket = event.Records[0].s3.bucket.name;
        const key = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, ' '));
        
        console.log(`Processing image from bucket: ${bucket}, key: ${key}`);

        // Check if this is a supported image format
        const format = key.split('.').pop().toLowerCase();
        if (!SUPPORTED_FORMATS.includes(format)) {
            console.log(`Unsupported format: ${format}. Skipping processing.`);
            return {
                statusCode: 400,
                body: JSON.stringify({ error: `Unsupported image format: ${format}` })
            };
        }
        
        // Get the image from S3
        console.log(`Fetching image from S3: ${bucket}/${key}`);
        const inputImage = await s3.getObject({
            Bucket: bucket,
            Key: key
        }).promise();
        
        console.log('Successfully retrieved image from S3');
        
        // Process image for different sizes
        const sizes = {
            thumbnail: { width: 150, height: 150 },
            medium: { width: 800, height: 800 },
            large: { width: 1600, height: 1600 }
        };

        const processedImages = await Promise.all(
            Object.entries(sizes).map(async ([size, dimensions]) => {
                console.log(`Processing ${size} version...`);
                const processedBuffer = await sharp(inputImage.Body)
                    .resize(dimensions.width, dimensions.height, {
                        fit: 'inside',
                        withoutEnlargement: true
                    })
                    .toBuffer();

                const targetKey = `${key.replace('uploads/', `${size}/`)}`;
                
                await s3.putObject({
                    Bucket: bucket,
                    Key: targetKey,
                    Body: processedBuffer,
                    ContentType: 'image/jpeg'
                }).promise();

                console.log(`Successfully uploaded ${size} version to ${targetKey}`);
                return { size, key: targetKey };
            })
        );

        // Send notification about processed images
        const message = {
            type: 'IMAGE_PROCESSED',
            message: {
                originalKey: key,
                processedVersions: processedImages,
                timestamp: new Date().toISOString()
            }
        };

        await sns.publish({
            TopicArn: process.env.SNS_TOPIC_ARN,
            Message: JSON.stringify(message),
            MessageAttributes: {
                type: {
                    DataType: 'String',
                    StringValue: 'IMAGE_PROCESSED'
                }
            }
        }).promise();

        console.log('Successfully published notification to SNS');

        return {
            statusCode: 200,
            body: JSON.stringify({
                message: 'Image processed successfully',
                processedImages
            })
        };
    } catch (error) {
        console.error('Error processing image:', error);
        
        // Log error to CloudWatch
        const cloudwatch = new AWS.CloudWatch();
        await cloudwatch.putMetricData({
            Namespace: 'Phoenix/ImageProcessor',
            MetricData: [{
                MetricName: 'ProcessingError',
                Value: 1,
                Unit: 'Count',
                Dimensions: [{
                    Name: 'Environment',
                    Value: process.env.AWS_LAMBDA_FUNCTION_NAME.includes('-dev') ? 'development' : 'production'
                }]
            }]
        }).promise();
        
        return {
            statusCode: 500,
            body: JSON.stringify({
                error: 'Error processing image',
                message: error.message
            })
        };
    }
}; 