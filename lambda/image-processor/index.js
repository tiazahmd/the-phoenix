const AWS = require('aws-sdk');
const sharp = require('sharp');
const s3 = new AWS.S3();

const SUPPORTED_FORMATS = ['jpg', 'jpeg', 'png', 'webp'];
const SIZES = [
    { width: 100, height: 100, suffix: 'thumbnail' },
    { width: 800, height: null, suffix: 'medium' },
    { width: 1200, height: null, suffix: 'large' }
];

exports.handler = async (event) => {
    try {
        console.log('Processing event:', JSON.stringify(event, null, 2));
        
        const bucket = event.Records[0].s3.bucket.name;
        const key = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, ' '));
        
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
        
        // Process image for each size
        const processedImages = await Promise.all(SIZES.map(async (size) => {
            console.log(`Processing size: ${size.suffix}`);
            
            const resizedImage = await sharp(inputImage.Body)
                .resize(size.width, size.height, {
                    fit: 'inside',
                    withoutEnlargement: true
                })
                .toFormat(format)
                .toBuffer();
            
            const newKey = `${key.substring(0, key.lastIndexOf('.'))}/${size.suffix}.${format}`;
            
            // Upload to S3
            await s3.putObject({
                Bucket: bucket,
                Key: newKey,
                Body: resizedImage,
                ContentType: `image/${format}`
            }).promise();
            
            return {
                size: size.suffix,
                key: newKey
            };
        }));
        
        console.log('Successfully processed images:', JSON.stringify(processedImages, null, 2));
        
        // Publish SNS notification about successful processing
        const sns = new AWS.SNS();
        await sns.publish({
            TopicArn: process.env.SNS_TOPIC_ARN,
            Message: JSON.stringify({
                type: 'IMAGE_PROCESSED',
                originalImage: key,
                processedImages: processedImages,
                timestamp: new Date().toISOString()
            })
        }).promise();
        
        return {
            statusCode: 200,
            body: JSON.stringify({
                message: 'Image processed successfully',
                processedImages: processedImages
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