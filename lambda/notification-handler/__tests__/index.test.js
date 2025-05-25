const AWS = require('aws-sdk');
const { handler } = require('../index');

// Mock AWS SDK
jest.mock('aws-sdk', () => ({
    SNS: jest.fn(() => ({
        publish: jest.fn().mockReturnValue({
            promise: jest.fn().mockResolvedValue({}),
        }),
    })),
}));

describe('Notification Handler Lambda', () => {
    const mockUserRegistrationEvent = {
        body: JSON.stringify({
            type: 'USER_REGISTRATION',
            message: {
                userId: '123',
                email: 'test@example.com',
                timestamp: '2024-01-20T12:00:00Z',
            },
        }),
    };

    const mockImageProcessedEvent = {
        body: JSON.stringify({
            type: 'IMAGE_PROCESSED',
            message: {
                imageId: '456',
                userId: '123',
                sizes: ['thumbnail', 'medium', 'large'],
                timestamp: '2024-01-20T12:00:00Z',
            },
        }),
    };

    beforeEach(() => {
        // Clear all mocks before each test
        jest.clearAllMocks();
        process.env.SNS_TOPIC_ARN = 'mock-sns-topic-arn';
    });

    test('handles user registration notification', async () => {
        const result = await handler(mockUserRegistrationEvent);

        // Verify SNS was initialized
        expect(AWS.SNS).toHaveBeenCalled();

        // Verify SNS publish was called with correct parameters
        const snsInstance = AWS.SNS.mock.results[0].value;
        expect(snsInstance.publish).toHaveBeenCalledWith({
            TopicArn: 'mock-sns-topic-arn',
            Message: expect.stringContaining('USER_REGISTRATION'),
            MessageAttributes: expect.objectContaining({
                notificationType: {
                    DataType: 'String',
                    StringValue: 'USER_REGISTRATION',
                },
            }),
        });

        // Verify successful response
        expect(result).toEqual({
            statusCode: 200,
            body: expect.stringContaining('Notification processed successfully'),
        });
    });

    test('handles image processed notification', async () => {
        const result = await handler(mockImageProcessedEvent);

        // Verify SNS publish was called with correct parameters
        const snsInstance = AWS.SNS.mock.results[0].value;
        expect(snsInstance.publish).toHaveBeenCalledWith({
            TopicArn: 'mock-sns-topic-arn',
            Message: expect.stringContaining('IMAGE_PROCESSED'),
            MessageAttributes: expect.objectContaining({
                notificationType: {
                    DataType: 'String',
                    StringValue: 'IMAGE_PROCESSED',
                },
            }),
        });

        expect(result).toEqual({
            statusCode: 200,
            body: expect.stringContaining('Notification processed successfully'),
        });
    });

    test('handles invalid notification structure', async () => {
        const invalidEvent = {
            body: JSON.stringify({
                type: 'INVALID_TYPE',
                // Missing message object
            }),
        };

        const result = await handler(invalidEvent);

        expect(result).toEqual({
            statusCode: 400,
            body: expect.stringContaining('Invalid notification structure'),
        });
    });

    test('handles SNS publish errors', async () => {
        // Mock SNS publish to throw an error
        const snsInstance = AWS.SNS.mock.results[0].value;
        snsInstance.publish.mockReturnValue({
            promise: jest.fn().mockRejectedValue(new Error('SNS Error')),
        });

        const result = await handler(mockUserRegistrationEvent);

        expect(result).toEqual({
            statusCode: 500,
            body: expect.stringContaining('Error processing notification'),
        });
    });
}); 