## Tech Stack

* **Front-End (iOS-only):** SwiftUI with Combine
* **Back-End:**

  * **Local Dev/Test:** Docker Compose running Django, PostgreSQL, and a Cognito mock server; pytest for testing with coverage reports
  * **Production:** AWS Fargate containers for Django services + AWS RDS (PostgreSQL)
* **Database:** PostgreSQL
* **Authentication:** AWS Cognito (Email/Password, SMS OTP, Biometric unlock)
* **API:** REST
* **Real-Time:** WebSockets
* **Push Notifications:** AWS SNS → APNs
* **State Management:** SwiftUI native state + Combine
* **CI/CD:** GitHub Actions (pipelines for build, test, lint, deploy)
* **Analytics:** Firebase Analytics
* **Crash Reporting:** Sentry
* **AI Personalization:** OpenAI API (ChatGPT/GPT-4) for quizzes, scenario branching, audio scripts

## Version Requirements & Dependencies

### iOS Requirements
* **iOS Version:** 17.0+
* **Swift Version:** 5.9
* **SwiftUI Version:** 5.0
* **Xcode Version:** 15.0+
* **Combine Version:** 4.0
* **Key Dependencies:**
  * Firebase iOS SDK: Latest
  * Sentry iOS SDK: Latest
  * AWS iOS SDK: Latest

### Backend Requirements
* **Python Version:** 3.12+
* **Django Version:** 5.0
* **Django REST Framework:** 3.14+
* **PostgreSQL Version:** 16
* **Key Dependencies:**
  * openai: Latest
  * pytest: Latest
  * celery: Latest
  * channels: Latest (for WebSocket)

### Infrastructure Requirements
* **Docker Version:** Latest
* **AWS Services Versions:**
  * ECS/Fargate: Latest
  * RDS PostgreSQL: 16
  * Cognito: Latest
  * SNS: Latest
  * CloudWatch: Latest

## Development Environment Setup

### Local Development Prerequisites
1. **iOS Development:**
   * macOS Sonoma 14.0+
   * Xcode 15.0+
   * CocoaPods or Swift Package Manager
   * iOS Simulator or physical device running iOS 17.0+

2. **Backend Development:**
   * Docker Desktop
   * Python 3.12+
   * Poetry or virtualenv
   * PostgreSQL 16 client
   * AWS CLI v2

3. **Infrastructure:**
   * Terraform Latest
   * AWS CLI v2
   * Docker Compose

### Environment Variables

#### iOS (.env.development, .env.production)
```
OPENAI_API_KEY=
AWS_COGNITO_POOL_ID=
AWS_COGNITO_CLIENT_ID=
API_BASE_URL=
FIREBASE_CONFIG=
SENTRY_DSN=
```

#### Backend (.env.development, .env.test, .env.production)
```
DJANGO_SECRET_KEY=
DATABASE_URL=
OPENAI_API_KEY=
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_REGION=
COGNITO_USER_POOL_ID=
COGNITO_APP_CLIENT_ID=
SENTRY_DSN=
FIREBASE_CREDENTIALS=
```

## Credentials Guide

### OpenAI API
1. Visit https://platform.openai.com/
2. Sign up or log in to your OpenAI account
3. Go to API Keys section
4. Create a new API key
5. Store securely in your environment files
6. Never commit API keys to version control

### AWS Credentials
1. **AWS Account Setup:**
   * Create an AWS account if you don't have one
   * Enable MFA for root account
   * Create an IAM user with appropriate permissions
   * Generate Access Key ID and Secret Access Key

2. **Cognito Setup:**
   * Create a new User Pool in AWS Cognito
   * Configure app client
   * Note down Pool ID and Client ID
   * Configure authentication providers (email, SMS)

3. **Other AWS Services:**
   * Set up RDS instance for PostgreSQL
   * Configure SNS for notifications
   * Set up CloudWatch logging
   * Create necessary IAM roles for Fargate

### Firebase Setup
1. Create a new Firebase project
2. Add iOS app to the project
3. Download `GoogleService-Info.plist`
4. Generate Firebase Admin SDK credentials for backend
5. Configure Analytics in Firebase console

### Sentry Setup
1. Create account at https://sentry.io
2. Create new project for iOS
3. Create new project for Django
4. Get DSN keys for both projects
5. Configure error tracking and performance monitoring

### Local Development Database
1. **PostgreSQL Setup:**
   ```bash
   # Install PostgreSQL
   brew install postgresql@16
   
   # Start PostgreSQL service
   brew services start postgresql@16
   
   # Create development database
   createdb phoenix_dev
   createdb phoenix_test
   ```

2. **Database URL Format:**
   ```
   DATABASE_URL=postgresql://username:password@localhost:5432/phoenix_dev
   ```

### Django Secret Key
1. Generate a secure secret key:
   ```python
   python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'
   ```
2. Store in your .env file

### Environment File Management
1. **Never commit .env files to version control**
2. Create example files without sensitive data:
   * `.env.example`
   * `.env.development.example`
   * `.env.test.example`
   * `.env.production.example`

3. **Local Setup:**
   ```bash
   # Copy example files
   cp .env.development.example .env.development
   cp .env.test.example .env.test
   
   # Edit with your credentials
   nano .env.development
   ```

### Credential Security Best Practices
1. Use different credentials for each environment
2. Rotate credentials regularly
3. Follow principle of least privilege
4. Use secrets management service in production
5. Monitor for unauthorized access
6. Regular security audits
7. Implement proper error handling for credential failures

## Code Organization & Architecture

### iOS Project Structure
```
ios/
├── App/
│   ├── Features/
│   │   ├── Authentication/
│   │   ├── CheckIn/
│   │   ├── Quiz/
│   │   ├── Audio/
│   │   ├── Simulation/
│   │   ├── Dashboard/
│   │   ├── UrgeBuster/
│   │   ├── Tips/
│   │   └── Reflection/
│   ├── Core/
│   │   ├── Network/
│   │   ├── Storage/
│   │   ├── Authentication/
│   │   └── Analytics/
│   ├── UI/
│   │   ├── Components/
│   │   ├── Styles/
│   │   └── Resources/
│   └── Utils/
└── Tests/
```

### Backend Project Structure
```
backend/
├── apps/
│   ├── authentication/
│   ├── checkins/
│   ├── quizzes/
│   ├── exercises/
│   ├── simulations/
│   ├── dashboard/
│   ├── tips/
│   └── reflections/
├── core/
│   ├── ai/
│   ├── websockets/
│   ├── analytics/
│   └── notifications/
├── tests/
└── config/
```

## Security Requirements

### Authentication & Authorization
* Implement biometric authentication (Face ID/Touch ID)
* AWS Cognito for user management
* JWT token-based API authentication
* Role-based access control
* Session management & token refresh
* Secure password requirements
* Rate limiting on authentication endpoints

### Data Security
* End-to-end encryption for sensitive data
* Secure storage of API keys and credentials
* Data encryption at rest
* Secure backup procedures
* GDPR compliance measures
* Data retention policies

### API Security
* Input validation and sanitization
* HTTPS-only communication
* API rate limiting
* Request/Response validation
* Security headers implementation
* CORS policy configuration

## Performance Requirements

### iOS App Performance
* App launch time < 2 seconds
* UI response time < 100ms
* Smooth animations (60 fps)
* Offline functionality for core features
* Battery usage optimization
* Memory usage < 200MB
* Network request timeout < 10 seconds

### Backend Performance
* API response time < 200ms
* WebSocket latency < 100ms
* Database query optimization
* Caching strategy implementation
* Rate limiting configuration
* Resource scaling rules

### AI Integration Performance
* OpenAI API response time < 3 seconds
* Fallback mechanisms for AI failures
* Caching of common responses
* Token usage optimization
* Cost optimization strategies

## Monitoring & Analytics

### Error Tracking
* Sentry integration for both iOS and backend
* Custom error reporting
* Crash analytics
* Performance monitoring
* User session tracking

### Analytics Requirements
* User engagement metrics
* Feature usage statistics
* Performance metrics
* Conversion tracking
* Retention analytics
* Custom event tracking

### Health Monitoring
* AWS CloudWatch integration
* System health checks
* Resource utilization monitoring
* Alert configuration
* Logging strategy

## Deployment & CI/CD

### iOS Deployment
* TestFlight beta distribution
* App Store deployment pipeline
* Code signing configuration
* Build configuration management
* Version management

### Backend Deployment
* AWS Fargate deployment
* Database migration strategy
* Zero-downtime deployment
* Rollback procedures
* Environment promotion strategy

### CI/CD Pipeline
* GitHub Actions workflow
* Automated testing
* Code quality checks
* Security scanning
* Deployment automation

## App Spec Sheet: ADHD-Focused Recovery App: ADHD-Focused Recovery App

### 1. Vision & High-Level Goals

**Primary Objectives**

* Structured habit-building exercises & progress metrics
* Cognitive-behavioral tools (interactive quizzes, guided audio, scenario simulations, breathing/mindfulness timers)
* AI-powered personalized coaching content (via OpenAI API)

**Success Metrics**

* Day-over-day reduction in self-reported trigger events
* Completion rates of daily exercises

**Tone & Brand Feel**

* Clinical & Structured: 50%
* Warm & Encouraging: 15%
* Playful & Gamified: 15%
* Minimal & Focused: 20%

**Personalization Level**

* High: Tailored exercises based on user inputs and behavior

**Community Features**

* None (solo experience only)

### 2. User Persona & Core Workflows

**Persona**

* Age: 26–35, working professional
* Tech comfort: Advanced

**Daily Usage Context**

* On-the-go quick hits when urges strike
* Scheduled reminder notifications

**Pain Points & Needs**

* Impulsive urges
* Accountability
* Secondary: Structure & encouragement

**Core Workflows**

1. Quick check-in (mood/urge slider + log)
2. Daily quiz (MCQ + instant feedback)
3. Audio exercise (2–3 min guided prompts)
4. Scenario simulation (AI-driven branching)
5. Progress dashboard (streaks & metrics)
6. "Urge buster" one-tap distraction (puzzles, cold-water timer, two-factor prompts, check-ins, memory flashbacks)
7. Personalized tips feed (infinite scroll + post-quiz tips)
8. Weekly reflection (summary chart & AI-written recap)

**Notification Preferences**

* Silent push notifications with badge indicators

### 3. Feature List & Data Models

#### 3.1 Onboarding & Authentication

* Biometric unlock (Face ID / Touch ID)
* AWS Cognito: Email/Password or SMS OTP

#### 3.2 Quick Check-In Screen

* Inputs: Timestamp, Mood slider, Urge intensity slider, Trigger context
* Endpoint: `POST /checkins`
* Model: `id, user_id, timestamp, mood, trigger_context, note, urge_level, exercise_completed`

#### 3.3 Daily Quiz

* AI-generated MCQs based on interest domains
* Domains: RDR2, Cyberpunk 2077, Ghost of Tsushima, Football Manager, Tech Trivia, Real Madrid, Historical Events, Sci-Fi, Sherlock Holmes, Guitar Basics, Harry Potter
* Tie-back style: Direct lesson + actionable tip
* Dynamic question count until user stops
* Triggers: every check-in & urge-buster
* Endpoints:

  * `POST /quizzes` → generate quiz
  * `POST /quizzes/{quiz_id}/submit` → evaluate

#### 3.4 Audio Exercise Screen

* AI-generated TTS scripts
* Endpoint: `POST /exercises/audio?theme=...`
* Model: `id, type, title, payload (script + TTS metadata), duration_sec`

#### 3.5 Scenario Simulation Screen

* AI-driven branching per user history
* Endpoints:

  * `POST /simulations/start`
  * `POST /simulations/{sim_id}/choose`

#### 3.6 Progress Dashboard

* Widgets: Streak count, Craving trend chart, Quiz history, Exercise count, Badges, Upcoming tasks
* Endpoint: `GET /dashboard?range=...`

#### 3.7 Urge Buster Tool

* Sub-tools: Quick puzzle, Cold-water timer, Two-factor prompts, Random safety check, Memory flashback

#### 3.8 Personalized Tips Feed

* Infinite scroll + quiz-integrated tips
* Endpoint: `GET /tips?after_id=...` & `GET /quizzes/{id}/tips`

#### 3.9 Weekly Reflection

* Summary chart & AI-written recap
* Endpoint: `GET /reflections/weekly`

#### 3.10 Settings & Notifications

* Settings: Delivery window, Badge-only style, No autoplay, No data export
* Endpoints: `GET /settings`, `PUT /settings`

#### 3.11 Data Models

* **CheckIn:** id, user\_id, timestamp, mood, trigger\_context, note, urge\_level, exercise\_completed
* **Exercise:** id, type, title, content\_url, duration\_sec, payload, difficulty\_level, created\_at

---

## 4. Testing Strategy

To ensure complete coverage and edge-case handling, we will:

1. **Generate Tests for Every Feature**

   * Use pytest (backend) and XCTest (iOS) to write unit and integration tests for each endpoint and UI component.
2. **Include All Edge Cases**

   * Define test matrices for boundary values (e.g., mood/urge slider min/max), network failures, invalid inputs, and authentication flows.
3. **Mock Data Only in Tests**

   * Use factory fixtures and mock servers (e.g., pytest-mock, Moto for AWS Cognito) to simulate external dependencies.
4. **CI Integration**

   * Run full test suite in GitHub Actions on every pull request, requiring 100% pass rate and coverage threshold (e.g., >90%).
5. **Environment Separation**

   * Execute tests against a dedicated test database (`.env.test`), isolating test data from development and production.
6. **Automate Regression & Smoke Tests**

   * Include end-to-end smoke tests (e.g., navigation flows in SwiftUI) and regression checks in CI to catch unintended breaks quickly.
