# Phoenix Lambda Functions

This directory contains AWS Lambda functions for the Phoenix project.

## Functions

### Image Processor (`image-processor/`)

A Lambda function triggered by S3 events to process uploaded images. It:
- Creates multiple sizes (thumbnail, medium, large) of uploaded images
- Stores processed images back in S3
- Sends notifications via SNS when processing is complete

#### Environment Variables
- `SNS_TOPIC_ARN`: ARN of the SNS topic for notifications

### Notification Handler (`notification-handler/`)

A Lambda function triggered by SNS notifications to send email notifications. It:
- Receives notifications from the Image Processor
- Sends email notifications via SES
- Handles different notification types

#### Environment Variables
- `SOURCE_EMAIL`: Email address to send notifications from
- `DESTINATION_EMAIL`: Email address to send notifications to

## Development

### Prerequisites
- Node.js 20.x
- npm 10.x

### Setup
1. Install root dependencies:
   ```bash
   npm install
   ```

2. Install function dependencies:
   ```bash
   cd image-processor && npm install
   cd ../notification-handler && npm install
   ```

### Testing
Run tests for all functions:
```bash
npm test
```

Or test individual functions:
```bash
cd image-processor && npm test
cd ../notification-handler && npm test
```

### Linting
Run ESLint for all functions:
```bash
npm run lint
```

## CI/CD

The functions are automatically tested and deployed using GitHub Actions. The workflow:
1. Runs tests
2. Checks code style with ESLint
3. Scans for security vulnerabilities with Snyk
4. Uploads test coverage reports

## Security

- All functions use IAM roles with least privilege
- Environment variables are managed securely
- Dependencies are regularly scanned for vulnerabilities
- Input validation is implemented for all handlers

## Monitoring

- CloudWatch logs are enabled for all functions
- Error tracking and reporting is implemented
- Performance metrics are collected
- SNS notifications for critical errors 