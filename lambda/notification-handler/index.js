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
        
        // Determine the SNS topic based on environment
        const topicArn = process.env.AWS_LAMBDA_FUNCTION_NAME.includes('-dev')
            ? 'arn:aws:sns:us-west-2:947502101623:phoenix-notifications-dev'
            : 'arn:aws:sns:us-west-2:947502101623:phoenix-notifications-prod-final';
        
        // Add metadata
        const enrichedNotification = {
            ...notification,
            timestamp: new Date().toISOString(),
            environment: process.env.AWS_LAMBDA_FUNCTION_NAME.includes('-dev') ? 'development' : 'production',
            version: '1.0'
        };
        
        // Log notification to CloudWatch
        console.log('Enriched notification:', JSON.stringify(enrichedNotification, null, 2));
        
        // Publish to SNS
        const snsResponse = await sns.publish({
            TopicArn: topicArn,
            Message: JSON.stringify(enrichedNotification),
            MessageAttributes: {
                'NotificationType': {
                    DataType: 'String',
                    StringValue: notification.type
                },
                'Environment': {
                    DataType: 'String',
                    StringValue: enrichedNotification.environment
                }
            }
        }).promise();
        
        console.log('Successfully published to SNS:', JSON.stringify(snsResponse, null, 2));
        
        // Track metrics
        const cloudwatch = new AWS.CloudWatch();
        await cloudwatch.putMetricData({
            Namespace: 'Phoenix/NotificationHandler',
            MetricData: [{
                MetricName: 'NotificationProcessed',
                Value: 1,
                Unit: 'Count',
                Dimensions: [
                    {
                        Name: 'Environment',
                        Value: enrichedNotification.environment
                    },
                    {
                        Name: 'NotificationType',
                        Value: notification.type
                    }
                ]
            }]
        }).promise();
        
        return {
            statusCode: 200,
            body: JSON.stringify({
                message: 'Notification processed successfully',
                notificationId: snsResponse.MessageId,
                notificationType: notification.type
            })
        };
        
    } catch (error) {
        console.error('Error processing notification:', error);
        
        // Log error to CloudWatch
        const cloudwatch = new AWS.CloudWatch();
        await cloudwatch.putMetricData({
            Namespace: 'Phoenix/NotificationHandler',
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
                error: 'Error processing notification',
                message: error.message
            })
        };
    }
}; 