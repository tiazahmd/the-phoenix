const AWS = require('aws-sdk');

// Import the handler
const { handler } = require('../src/index');

// Mock AWS SDK
jest.mock('aws-sdk', () => {
    const mockSESInstance = {
        sendEmail: jest.fn().mockReturnValue({
            promise: jest.fn().mockResolvedValue({
                MessageId: 'mock-message-id',
            }),
        }),
    };

    return {
        SES: jest.fn(() => mockSESInstance),
    };
});

describe('Notification Handler Lambda', () => {
    let mockSES;

    beforeEach(() => {
        // Clear all mocks
        jest.clearAllMocks();

        // Get mock instance
        mockSES = new AWS.SES();

        // Set environment variables
        process.env.SOURCE_EMAIL = 'test@example.com';
        process.env.DESTINATION_EMAIL = 'admin@example.com';
    });

    const mockEvent = {
        Records: [{
            Sns: {
                Message: JSON.stringify({
                    bucket: 'phoenix-storage-dev',
                    key: 'uploads/test-image.jpg',
                    sizes: ['thumbnail', 'medium', 'large'],
                }),
                MessageAttributes: {
                    type: {
                        Value: 'IMAGE_PROCESSED',
                    },
                },
            },
        }],
    };

    test('sends email notification successfully', async () => {
        const result = await handler(mockEvent);

        // Verify SES sendEmail was called
        expect(mockSES.sendEmail).toHaveBeenCalledWith({
            Source: 'test@example.com',
            Destination: {
                ToAddresses: ['admin@example.com'],
            },
            Message: {
                Subject: {
                    Data: 'Image Processing Complete',
                },
                Body: {
                    Text: {
                        Data: expect.stringContaining('phoenix-storage-dev'),
                    },
                },
            },
        });

        // Verify successful response
        expect(result).toEqual({
            statusCode: 200,
            body: expect.any(String),
        });
    });

    test('handles errors gracefully', async () => {
        // Mock SES sendEmail to throw an error
        mockSES.sendEmail.mockReturnValue({
            promise: jest.fn().mockRejectedValue(new Error('SES Error')),
        });

        const result = await handler(mockEvent);

        expect(result).toEqual({
            statusCode: 500,
            body: expect.stringContaining('Error sending notification'),
        });
    });

    test('handles unsupported message type', async () => {
        const unsupportedEvent = {
            Records: [{
                Sns: {
                    Message: JSON.stringify({
                        bucket: 'phoenix-storage-dev',
                        key: 'uploads/test-image.jpg',
                    }),
                    MessageAttributes: {
                        type: {
                            Value: 'UNSUPPORTED_TYPE',
                        },
                    },
                },
            }],
        };

        const result = await handler(unsupportedEvent);

        expect(result).toEqual({
            statusCode: 500,
            body: expect.stringContaining('Unsupported message type'),
        });

        // Verify SES sendEmail was not called
        expect(mockSES.sendEmail).not.toHaveBeenCalled();
    });
});
