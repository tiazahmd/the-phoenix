const AWS = require('aws-sdk');
const sharp = require('sharp');
const { handler } = require('../index');

// Mock AWS SDK
jest.mock('aws-sdk', () => ({
    S3: jest.fn(() => ({
        getObject: jest.fn().mockReturnValue({
            promise: jest.fn().mockResolvedValue({
                Body: Buffer.from('fake-image-data'),
            }),
        }),
        putObject: jest.fn().mockReturnValue({
            promise: jest.fn().mockResolvedValue({}),
        }),
    })),
    SNS: jest.fn(() => ({
        publish: jest.fn().mockReturnValue({
            promise: jest.fn().mockResolvedValue({}),
        }),
    })),
}));

// Mock sharp
jest.mock('sharp', () => jest.fn(() => ({
    resize: jest.fn().mockReturnThis(),
    toBuffer: jest.fn().mockResolvedValue(Buffer.from('processed-image')),
})));

describe('Image Processor Lambda', () => {
    const mockEvent = {
        Records: [{
            s3: {
                bucket: { name: 'phoenix-storage-dev' },
                object: { key: 'uploads/test-image.jpg' },
            },
        }],
    };

    beforeEach(() => {
        // Clear all mocks before each test
        jest.clearAllMocks();
        process.env.SNS_TOPIC_ARN = 'mock-sns-topic-arn';
    });

    test('processes image and creates thumbnails', async () => {
        const result = await handler(mockEvent);
        
        // Verify S3 getObject was called
        expect(AWS.S3).toHaveBeenCalled();
        const s3Instance = AWS.S3.mock.results[0].value;
        expect(s3Instance.getObject).toHaveBeenCalledWith({
            Bucket: 'phoenix-storage-dev',
            Key: 'uploads/test-image.jpg',
        });

        // Verify sharp processing
        expect(sharp).toHaveBeenCalledWith(Buffer.from('fake-image-data'));
        const sharpInstance = sharp.mock.results[0].value;
        expect(sharpInstance.resize).toHaveBeenCalled();
        expect(sharpInstance.toBuffer).toHaveBeenCalled();

        // Verify S3 putObject was called for each size
        expect(s3Instance.putObject).toHaveBeenCalledTimes(3); // thumbnail, medium, large

        // Verify SNS notification was sent
        expect(AWS.SNS).toHaveBeenCalled();
        const snsInstance = AWS.SNS.mock.results[0].value;
        expect(snsInstance.publish).toHaveBeenCalledWith({
            TopicArn: 'mock-sns-topic-arn',
            Message: expect.any(String),
        });

        // Verify successful response
        expect(result).toEqual({
            statusCode: 200,
            body: expect.any(String),
        });
    });

    test('handles errors gracefully', async () => {
        // Mock S3 getObject to throw an error
        const s3Instance = AWS.S3.mock.results[0].value;
        s3Instance.getObject.mockReturnValue({
            promise: jest.fn().mockRejectedValue(new Error('S3 Error')),
        });

        const result = await handler(mockEvent);

        expect(result).toEqual({
            statusCode: 500,
            body: expect.stringContaining('Error processing image'),
        });
    });
}); 