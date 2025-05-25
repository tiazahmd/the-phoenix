const AWS = require('aws-sdk');

const ses = new AWS.SES();

exports.handler = async (event) => {
    try {
        console.log('Processing event:', JSON.stringify(event));

        const snsMessage = JSON.parse(event.Records[0].Sns.Message);
        const messageType = event.Records[0].Sns.MessageAttributes.type.Value;

        if (messageType !== 'IMAGE_PROCESSED') {
            throw new Error(`Unsupported message type: ${messageType}`);
        }

        const emailParams = {
            Source: process.env.SOURCE_EMAIL,
            Destination: {
                ToAddresses: [process.env.DESTINATION_EMAIL],
            },
            Message: {
                Subject: {
                    Data: 'Image Processing Complete',
                },
                Body: {
                    Text: {
                        Data: 'Image processing completed successfully.\n\n'
                              + `Bucket: ${snsMessage.bucket}\n`
                              + `Original Image: ${snsMessage.key}\n`
                              + `Processed Sizes: ${snsMessage.sizes.join(', ')}\n\n`
                              + `Time: ${new Date().toISOString()}`,
                    },
                },
            },
        };

        await ses.sendEmail(emailParams).promise();
        console.log('Successfully sent email notification');

        return {
            statusCode: 200,
            body: JSON.stringify({
                message: 'Notification sent successfully',
            }),
        };
    } catch (error) {
        console.error('Error sending notification:', error);
        return {
            statusCode: 500,
            body: JSON.stringify({
                message: 'Error sending notification',
                error: error.message,
            }),
        };
    }
};
