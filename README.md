# The Phoenix Project

A modern, serverless application built with AWS Lambda, iOS, and Django.

## Project Structure

```
.
├── lambda/                  # AWS Lambda Functions
│   ├── image-processor/     # Image processing Lambda function
│   └── notification-handler/# Notification handling Lambda function
├── ios/                    # iOS SwiftUI Application
├── backend/                # Django Backend
├── tests/                  # Integration Tests
└── docs/                   # Project Documentation
```

## Lambda Functions

### Image Processor
Handles image processing using the Sharp library:
- Image resizing
- Format conversion
- Optimization
- Metadata handling

### Notification Handler
Manages notifications using AWS SES:
- Email notifications
- System alerts
- User communications

## Getting Started

### Prerequisites
- Node.js 20.x
- Python 3.12
- AWS CLI
- Xcode 15.0+

### Installation

1. Clone the repository:
```bash
git clone https://github.com/tiazahmd/the-phoenix.git
cd the-phoenix
```

2. Install dependencies:
```bash
npm ci
```

3. Set up AWS credentials:
```bash
aws configure
```

### Development

#### Running Tests
```bash
npm test
```

#### Linting
```bash
npm run lint
```

#### Local Development
Each component can be developed independently:

- Lambda Functions:
  ```bash
  cd lambda/[function-name]
  npm run dev
  ```

- iOS App:
  ```bash
  cd ios
  xed .
  ```

- Django Backend:
  ```bash
  cd backend
  python manage.py runserver
  ```

## CI/CD Pipeline

The project uses GitHub Actions for CI/CD:

- **CI Pipeline**: Runs on every push and pull request
  - Unit tests
  - Code linting
  - Security scanning

- **CD Pipeline**: Deploys to AWS on merge to main
  - Automatic deployment to development
  - Manual approval for production

## Security

- All dependencies are regularly scanned for vulnerabilities
- Production deployments require manual approval
- Secrets are managed through GitHub Secrets and AWS Parameter Store

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to your branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

Imtiaz Ahmed - [@tiazahmd](https://github.com/tiazahmd) 