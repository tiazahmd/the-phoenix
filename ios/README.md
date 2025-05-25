# Phoenix iOS App

An ADHD-focused recovery application built with SwiftUI, designed to help users manage impulsive urges through structured cognitive-behavioral tools and AI-powered personalized coaching.

## 🎯 Project Overview

Phoenix is a comprehensive personal development platform specifically designed for individuals with ADHD who are working on recovery from impulsive behaviors. The app provides evidence-based tools, real-time support, and personalized interventions to help users build healthier habits and manage urges effectively.

### Target Audience
- Age: 26-35, working professionals
- Tech comfort: Advanced
- Primary need: Managing impulsive urges and building accountability

## ✨ Current Features (v0.1.0-alpha)

### ✅ Implemented
- **Check-In System**: Mood/urge sliders with trigger context logging
- **Daily Quiz**: AI-generated MCQs across 11 interest domains (RDR2, Cyberpunk, Tech Trivia, etc.)
- **Urge Buster Tools**: 5 quick intervention tools (puzzles, cold water timer, two-factor prompts, safety checks, memory flashbacks)
- **Tips Feed**: Personalized recovery tips with infinite scroll and category filtering
- **Dashboard**: Progress tracking with streaks and quick actions
- **Audio Exercises**: Guided exercises with multiple themes (breathing, mindfulness, grounding, motivation)

### 🚧 In Development
- Authentication system (AWS Cognito + Biometric unlock)
- Scenario simulations (AI-driven branching)
- Weekly reflection with AI-generated summaries
- Real-time notifications (AWS SNS)
- Offline functionality
- Core Data integration

### 📋 Planned Features
- End-to-end encryption
- Advanced analytics (Firebase)
- Crash reporting (Sentry)
- WebSocket real-time features
- TestFlight beta distribution

## 🛠 Technical Stack

### Core Technologies
- **Frontend**: SwiftUI 5.0 + Combine 4.0
- **Backend**: Django 5.0 + Django REST Framework 3.14+
- **Database**: PostgreSQL 16
- **Authentication**: AWS Cognito (Email/Password, SMS OTP, Biometric)
- **AI**: OpenAI API (GPT-4) for personalized content
- **Analytics**: Firebase Analytics
- **Crash Reporting**: Sentry
- **Push Notifications**: AWS SNS → APNs

### iOS Requirements
- **iOS Version**: 17.0+
- **Swift Version**: 5.9
- **Xcode Version**: 15.0+
- **Architecture**: MVVM with SwiftUI native state management

## 🚀 Getting Started

### Prerequisites
- macOS Sonoma 14.0+
- Xcode 15.0+
- iOS Simulator or physical device running iOS 17.0+

### Installation

1. **Clone the repository**:
```bash
git clone https://github.com/tiazahmd/the-phoenix.git
cd the-phoenix/ios
```

2. **Install development tools**:
```bash
# Install XcodeGen for project generation
brew install xcodegen

# Install SwiftLint for code style enforcement
brew install swiftlint
```

3. **Generate Xcode project**:
```bash
xcodegen generate
```

4. **Open the project**:
```bash
open Phoenix.xcodeproj
```

5. **Build and run**:
   - Select a simulator or device
   - Press `Cmd + R` to build and run

## 📁 Project Structure

```
Phoenix/
├── Sources/
│   ├── App/                    # App entry point and configuration
│   │   └── PhoenixApp.swift   # Main app file
│   ├── Features/              # Feature-based modules
│   │   ├── CheckIn/           # Mood/urge tracking system
│   │   ├── Quiz/              # AI-generated quiz system
│   │   ├── UrgeBuster/        # Quick intervention tools
│   │   ├── Tips/              # Personalized tips feed
│   │   ├── Dashboard/         # Progress tracking and metrics
│   │   └── Audio/             # Guided audio exercises
│   ├── Core/                  # Core functionality (planned)
│   │   ├── Network/           # API integration layer
│   │   ├── Storage/           # Core Data models
│   │   ├── Authentication/    # Auth management
│   │   └── Analytics/         # Analytics tracking
│   ├── UI/                    # Reusable UI components (planned)
│   │   ├── Components/        # Custom SwiftUI components
│   │   ├── Styles/            # Design system
│   │   └── Resources/         # Assets and resources
│   └── Utils/                 # Utility functions (planned)
├── Tests/                     # Unit and UI tests (planned)
├── Configuration/             # Project configuration
│   └── Info.plist            # App configuration
└── Resources/                 # Assets and resources (planned)
```

## 🏗 Architecture

### Design Patterns
- **MVVM**: Model-View-ViewModel architecture
- **Feature-based organization**: Each feature is self-contained
- **Reactive programming**: Combine for data flow
- **Dependency injection**: Protocol-based dependencies (planned)

### Data Flow
1. **UI Layer**: SwiftUI views with @State and @StateObject
2. **Business Logic**: ViewModels handling user interactions
3. **Data Layer**: Core Data for local storage + REST API for remote data
4. **Network Layer**: URLSession with Combine publishers

### Key Principles
- **Clinical & Structured**: 50% of design decisions
- **Warm & Encouraging**: 15% of user experience
- **Playful & Gamified**: 15% of interactions
- **Minimal & Focused**: 20% of interface design

## 🧪 Testing Strategy

### Current Status
- **Unit Tests**: Not implemented (planned)
- **UI Tests**: Not implemented (planned)
- **Integration Tests**: Not implemented (planned)

### Planned Testing
- **XCTest** for unit and integration tests
- **Test coverage requirement**: >90%
- **Mock data factories** for consistent testing
- **Automated regression testing** in CI/CD
- **Performance testing** for critical paths

## 📊 Performance Requirements

### Target Metrics
- **App launch time**: < 2 seconds
- **UI response time**: < 100ms
- **Smooth animations**: 60 fps
- **Memory usage**: < 200MB
- **Network timeout**: < 10 seconds
- **Offline functionality**: Core features available offline

## 🔒 Security & Privacy

### Implemented
- **SwiftUI secure coding practices**
- **No hardcoded credentials**

### Planned
- **Biometric authentication** (Face ID/Touch ID)
- **End-to-end encryption** for sensitive data
- **Secure keychain storage** for credentials
- **GDPR compliance** measures
- **Data retention policies**

## 🎨 Code Style

We enforce consistent code style using SwiftLint:

```bash
# Run SwiftLint
swiftlint

# Auto-fix issues where possible
swiftlint --fix
```

Configuration is defined in `.swiftlint.yml` with custom rules for:
- Line length limits (120 characters)
- Function complexity
- File organization
- Naming conventions

## 🚀 Deployment

### Development
- **Local development**: Xcode simulator
- **Device testing**: iOS 17.0+ devices

### Planned Distribution
- **TestFlight**: Beta testing distribution
- **App Store**: Production release
- **CI/CD**: GitHub Actions for automated builds

## 🤝 Contributing

### Development Workflow
1. Create a feature branch from `main`
2. Implement changes following SPEC requirements
3. Run SwiftLint and fix any issues
4. Test on simulator and device
5. Submit pull request with detailed description

### Commit Convention
We follow conventional commits:
- `feat:` New features
- `fix:` Bug fixes
- `docs:` Documentation updates
- `style:` Code style changes
- `refactor:` Code refactoring
- `test:` Test additions/updates

## 📚 Documentation

- **SPEC.md**: Complete project specification
- **PROJECT_UPDATE.md**: Development history and status
- **CHANGELOG.md**: Version history and changes
- **API Documentation**: Available at backend `/swagger/`

## 🐛 Known Issues

### Current Limitations
- **No authentication**: Users can access all features without login
- **No data persistence**: Data is lost on app restart
- **No offline support**: Requires internet connection
- **Simulated API calls**: All backend integration is mocked
- **No push notifications**: Reminder system not implemented

### Performance Issues
- **Memory leaks**: Timer objects in UrgeBuster tools may not be properly cleaned up
- **State management**: Some views use inefficient state updates

## 📞 Support

For development questions or issues:
- **GitHub Issues**: [Create an issue](https://github.com/tiazahmd/the-phoenix/issues)
- **Documentation**: Check SPEC.md for detailed requirements
- **Project Updates**: See PROJECT_UPDATE.md for current status

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Note**: This is an early prototype (v0.1.0-alpha) focused on UI implementation and user experience validation. Core infrastructure features are planned for upcoming releases. 