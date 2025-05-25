const AWS = require('aws-sdk');
const sharp = require('sharp');
const { handler } = require('../src/index');

// Mock AWS SDK
jest.mock('aws-sdk', () => {
    const mockS3Instance = {
        getObject: jest.fn().mockReturnValue({
            promise: jest.fn().mockResolvedValue({
                Body: Buffer.from('fake-image-data'),
            }),
        }),
        putObject: jest.fn().mockReturnValue({
            promise: jest.fn().mockResolvedValue({}),
        }),
    };

    const mockSNSInstance = {
        publish: jest.fn().mockReturnValue({
            promise: jest.fn().mockResolvedValue({
                MessageId: 'mock-message-id',
            }),
        }),
    };

    return {
        S3: jest.fn(() => mockS3Instance),
        SNS: jest.fn(() => mockSNSInstance),
    };
});

// Mock sharp
jest.mock('sharp', () => jest.fn().mockImplementation(() => ({
    resize: jest.fn().mockReturnThis(),
    toBuffer: jest.fn().mockResolvedValue(Buffer.from('processed-image')),
})));

describe('Image Processor Lambda', () => {
    let mockS3;
    let mockSNS;

    beforeEach(() => {
        // Clear all mocks
        jest.clearAllMocks();

        // Get mock instances
        mockS3 = new AWS.S3();
        mockSNS = new AWS.SNS();

        // Set environment variables
        process.env.SNS_TOPIC_ARN = 'mock-sns-topic-arn';
    });

    const mockEvent = {
        Records: [{
            s3: {
                bucket: { name: 'phoenix-storage-dev' },
                object: { key: 'uploads/test-image.jpg' },
            },
        }],
    };

    test('processes image and creates thumbnails', async () => {
        const result = await handler(mockEvent);

        // Verify S3 getObject was called
        expect(mockS3.getObject).toHaveBeenCalledWith({
            Bucket: 'phoenix-storage-dev',
            Key: 'uploads/test-image.jpg',
        });

        // Verify sharp processing
        expect(sharp).toHaveBeenCalledWith(Buffer.from('fake-image-data'));

        // Verify S3 putObject was called for each size
        expect(mockS3.putObject).toHaveBeenCalledTimes(3);

        // Verify SNS notification was sent
        expect(mockSNS.publish).toHaveBeenCalledWith({
            TopicArn: 'mock-sns-topic-arn',
            Message: expect.any(String),
            MessageAttributes: {
                type: {
                    DataType: 'String',
                    StringValue: 'IMAGE_PROCESSED',
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
        // Mock S3 getObject to throw an error
        mockS3.getObject.mockReturnValue({
            promise: jest.fn().mockRejectedValue(new Error('S3 Error')),
        });

        const result = await handler(mockEvent);

        expect(result).toEqual({
            statusCode: 500,
            body: expect.stringContaining('Error processing image'),
        });
    });
});
