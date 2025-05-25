const AWS = require('aws-sdk');
const sns = new AWS.SNS();

const VALID_NOTIFICATION_TYPES = [
    'USER_REGISTERED',
    'USER_UPDATED',
    'USER_DELETED',
    'IMAGE_PROCESSED',
    'COMMENT_ADDED',
    'COMMENT_UPDATED',
    'COMMENT_DELETED',
    'POST_CREATED',
    'POST_UPDATED',
    'POST_DELETED'
];

exports.handler = async (event) => {
    try {
        console.log('Processing event:', JSON.stringify(event, null, 2));
        
        // Parse the incoming notification
        const notification = typeof event.body === 'string' ? JSON.parse(event.body) : event.body;
        
        // Validate notification structure
        if (!notification || !notification.type || !notification.message) {
            console.error('Invalid notification structure');
            return {
                statusCode: 400,
                body: JSON.stringify({
                    error: 'Invalid notification structure',
                    message: 'Required fields: type and message'
                })
            };
        }
        
        // Validate notification type
        if (!VALID_NOTIFICATION_TYPES.includes(notification.type)) {
            console.error(`Invalid notification type: ${notification.type}`);
            return {
                statusCode: 400,
                body: JSON.stringify({
                    error: 'Invalid notification type',
                    validTypes: VALID_NOTIFICATION_TYPES
                })
            };
        }
        
        // Publish to SNS
        const snsResponse = await sns.publish({
            TopicArn: process.env.SNS_TOPIC_ARN,
            Message: JSON.stringify(notification),
            MessageAttributes: {
                notificationType: {
                    DataType: 'String',
                    StringValue: notification.type
                }
            }
        }).promise();
        
        console.log('Successfully published to SNS:', JSON.stringify(snsResponse, null, 2));
        
        return {
            statusCode: 200,
            body: JSON.stringify({
                message: 'Notification processed successfully',
                notificationId: snsResponse.MessageId
            })
        };
        
    } catch (error) {
        console.error('Error processing notification:', error);
        return {
            statusCode: 500,
            body: JSON.stringify({
                error: 'Error processing notification',
                message: error.message
            })
        };
    }
}; 