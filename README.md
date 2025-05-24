# The Phoenix Project - AWS Lambda Functions

This repository contains AWS Lambda functions for image processing and notification handling in The Phoenix project.

## Architecture Overview

The project uses two main Lambda functions:

1. **Image Processor** (`phoenix-image-processor-dev/prod`)
   - Processes uploaded images in S3
   - Creates multiple image sizes (thumbnail, medium, large)
   - Publishes notifications about processed images

2. **Notification Handler** (`phoenix-notification-handler-dev/prod`)
   - Handles various types of notifications
   - Enriches notifications with metadata
   - Publishes to SNS topics

## Infrastructure Components

- **S3 Buckets**:
  - Development: `phoenix-storage-dev`
  - Production: `phoenix-storage-prod-final`

- **SNS Topics**:
  - Development: `phoenix-notifications-dev`
  - Production: `phoenix-notifications-prod-final`

- **IAM Role**: `PhoenixLambdaRole`

## Function Configurations

### Image Processor

```javascript
Configuration:
- Runtime: Node.js 20.x
- Memory: 256MB
- Timeout: 30 seconds
- Handler: index.handler
- Environment Variables:
  - SNS_TOPIC_ARN: arn:aws:sns:us-west-2:947502101623:phoenix-notifications-dev (dev)
  - SNS_TOPIC_ARN: arn:aws:sns:us-west-2:947502101623:phoenix-notifications-prod-final (prod)
```

Features:
- Supports JPG, JPEG, PNG, and WebP formats
- Creates three image sizes:
  - Thumbnail (100x100)
  - Medium (800px width)
  - Large (1200px width)
- Preserves aspect ratios
- Prevents image upscaling
- Publishes processing status to SNS

### Notification Handler

```javascript
Configuration:
- Runtime: Node.js 20.x
- Memory: 128MB
- Timeout: 3 seconds
- Handler: index.handler
```

Supported Notification Types:
- USER_REGISTERED
- USER_UPDATED
- USER_DELETED
- IMAGE_PROCESSED
- COMMENT_ADDED
- COMMENT_UPDATED
- COMMENT_DELETED
- POST_CREATED
- POST_UPDATED
- POST_DELETED

## IAM Policies

The functions use three main IAM policies:

1. **CloudWatch Policy** (`lambda-cloudwatch-policy.json`)
   - Allows logging and metrics
   - Enables performance monitoring

2. **SNS Policy** (`lambda-sns-policy.json`)
   - Enables publishing to SNS topics
   - Controls notification permissions

3. **S3 Policy** (`lambda-s3-policy.json`)
   - Allows reading from source buckets
   - Enables writing processed images

## Deployment

Use the deployment script to update the functions:

```bash
./deploy-lambdas.sh
```

The script handles:
- Code packaging
- Dependencies installation
- Lambda function updates
- Environment variable configuration

## Monitoring

Both functions implement CloudWatch metrics:

### Image Processor Metrics
- Namespace: `Phoenix/ImageProcessor`
- Metrics:
  - `ProcessingError`: Counts processing failures
  - Environment dimension tracks dev/prod errors

### Notification Handler Metrics
- Namespace: `Phoenix/NotificationHandler`
- Metrics:
  - `NotificationProcessed`: Tracks successful notifications
  - `ProcessingError`: Counts notification failures
  - Dimensions include Environment and NotificationType

## Error Handling

Both functions implement comprehensive error handling:
- Input validation
- Service error handling
- CloudWatch error logging
- Metric tracking for failures
- User-friendly error responses

## Security

Security measures implemented:
- IAM role-based access control
- Environment-specific resources
- Input validation and sanitization
- Secure error handling
- CloudWatch logging for audit trail

## Development Guidelines

1. **Testing**:
   - Test all changes in development first
   - Use appropriate test events
   - Verify CloudWatch logs
   - Check SNS notifications
   - Validate processed images

2. **Deployment**:
   - Always deploy to dev environment first
   - Verify functionality in dev
   - Update environment variables if needed
   - Check CloudWatch logs after deployment
   - Monitor metrics after deployment

3. **Monitoring**:
   - Watch CloudWatch metrics
   - Set up appropriate alarms
   - Monitor SNS delivery
   - Check S3 for processed images
   - Verify end-to-end flow

## Maintenance

Regular maintenance tasks:
1. Update Node.js runtime when new versions are available
2. Review and update IAM policies as needed
3. Monitor and optimize CloudWatch usage
4. Review and update memory/timeout configurations
5. Clean up old logs and processed images

## Troubleshooting

Common issues and solutions:

1. **Image Processing Failures**:
   - Check S3 permissions
   - Verify image format support
   - Check Lambda memory usage
   - Review sharp module installation

2. **Notification Failures**:
   - Verify SNS topic ARN
   - Check SNS permissions
   - Validate notification format
   - Review CloudWatch logs

3. **Permission Issues**:
   - Review IAM role configuration
   - Check policy attachments
   - Verify resource ARNs
   - Update policies if needed

## Contact

For issues or questions, contact the development team:
- Development Lead: [Your Name]
- Cloud Architecture: [Cloud Architect Name]
- DevOps: [DevOps Engineer Name] 