# Changelog

All notable changes to the Phoenix iOS app will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- Authentication system with AWS Cognito integration
- Biometric unlock (Face ID/Touch ID)
- Scenario simulation feature with AI-driven branching
- Weekly reflection with AI-generated summaries
- Real-time notifications via AWS SNS
- Core Data integration for offline functionality
- Firebase Analytics integration
- Sentry crash reporting
- End-to-end encryption for sensitive data
- TestFlight beta distribution setup

## [0.1.0-alpha] - 2024-01-XX

### Added
- **SPEC-Compliant Feature Set**: Complete restructuring to match project specification
- **Check-In System**: Primary entry point with mood/urge sliders (1-10 scale)
  - Trigger context logging with predefined categories
  - Quick actions when urge level exceeds 5
  - Visual feedback with color-coded sliders
- **Daily Quiz Feature**: AI-generated multiple choice questions
  - 11 interest domains (RDR2, Cyberpunk, Tech Trivia, History, Science, etc.)
  - Instant feedback with explanations
  - Recovery tips integrated into quiz results
  - Quiz history tracking
- **Urge Buster Tools**: 5 quick intervention tools
  - Quick Puzzle: Simple math problems for cognitive redirection
  - Cold Water Timer: 30-second guided cold water exposure
  - Two-Factor Prompts: Reflection questions before impulsive actions
  - Safety Check: Emergency contact and resource access
  - Memory Flashback: Positive memory visualization
- **Tips Feed**: Personalized recovery tips system
  - Infinite scroll with pagination
  - Category filtering (Mindfulness, Productivity, Health, Social, etc.)
  - Actionable tips with step-by-step instructions
  - Bookmark functionality
- **Dashboard**: Recovery-focused progress tracking
  - Current streak counter
  - Urge-free days tracking
  - Quick action buttons
  - Recent activity summary
- **Audio Exercises**: Guided audio content
  - Multiple themes (Breathing, Mindfulness, Grounding, Motivation)
  - AI-generated TTS scripts
  - Progress tracking
- **SwiftUI App Lifecycle**: Proper app configuration without SceneDelegate
- **Tab Navigation**: 5-tab structure (Check-In, Quiz, Dashboard, Urge Buster, Tips)

### Changed
- **Complete UI Restructuring**: Removed generic mindfulness features
- **ADHD Recovery Focus**: All features now target ADHD recovery specifically
- **Design Principles**: Implemented 50% Clinical, 15% Warm, 15% Gamified, 20% Minimal approach
- **Navigation Structure**: Changed from Dashboard/Exercises/Journal/Profile to recovery-focused tabs
- **Color Scheme**: Updated to use recovery-appropriate colors and visual feedback

### Removed
- **Generic Exercises View**: Replaced with specific Urge Buster tools
- **Journal Feature**: Removed generic journaling in favor of structured check-ins
- **Profile View**: Removed generic profile in favor of dashboard-focused approach
- **Mindfulness Exercises**: Removed generic mindfulness content
- **SceneDelegate**: Simplified to SwiftUI app lifecycle

### Fixed
- **Console Errors**: Resolved SceneDelegate configuration issues
- **Info.plist Configuration**: Fixed app lifecycle and permissions
- **List Scrolling**: Improved performance in Dashboard and Tips views
- **Project Generation**: XcodeGen now generates clean Xcode project
- **Navigation Issues**: Fixed tab switching and view state management

### Technical Details
- **iOS Target**: 17.0+
- **Swift Version**: 5.9
- **SwiftUI Version**: 5.0
- **Architecture**: MVVM with feature-based organization
- **Code Style**: SwiftLint enforcement with custom rules
- **Project Management**: XcodeGen for project file generation

### Known Issues
- **No Authentication**: All features accessible without login
- **No Data Persistence**: Data lost on app restart
- **Mock API Integration**: All backend calls are simulated
- **No Offline Support**: Requires internet connection
- **Memory Management**: Timer cleanup in UrgeBuster tools needs optimization

### Development Notes
- All API integration points are marked with TODO comments
- Sample data used for UI demonstration and testing
- Feature structure ready for backend integration
- UI components follow iOS 17 design guidelines

---

## [0.0.1] - 2024-01-XX (Initial Setup)

### Added
- **Initial Project Setup**: Basic SwiftUI project structure
- **XcodeGen Configuration**: Project generation setup
- **SwiftLint Integration**: Code style enforcement
- **Basic Navigation**: Tab-based navigation structure
- **Generic Features**: Initial mindfulness/journal features (later removed)

### Technical Setup
- iOS 17.0+ target configuration
- Swift Package Manager setup
- Basic project structure with feature modules
- Info.plist configuration
- SwiftLint rules configuration

---

## Version History Summary

| Version | Date | Focus | Status |
|---------|------|-------|--------|
| 0.1.0-alpha | 2024-01-XX | SPEC compliance & ADHD recovery features | Current |
| 0.0.1 | 2024-01-XX | Initial project setup | Superseded |

---

## Migration Notes

### From 0.0.1 to 0.1.0-alpha
- **Breaking Changes**: Complete feature set replacement
- **Data Migration**: Not applicable (no persistent data in 0.0.1)
- **API Changes**: All endpoints changed to recovery-focused
- **UI Changes**: Complete redesign with new navigation structure

### Upcoming Breaking Changes (0.2.0)
- Authentication requirement will be enforced
- Data models will change with Core Data integration
- API endpoints will require authentication tokens
- Offline functionality will change data flow patterns

---

## Development Workflow

### Commit Types Used
- `feat:` New features and major functionality
- `fix:` Bug fixes and issue resolution
- `docs:` Documentation updates
- `style:` Code style and formatting changes
- `refactor:` Code restructuring without feature changes
- `test:` Test additions and updates
- `chore:` Build process and tool updates

### Release Process
1. Feature development in feature branches
2. Code review and testing
3. Version bump and changelog update
4. Tag creation and release notes
5. TestFlight distribution (planned)
6. App Store submission (planned)

---

## Contributors

- **Lead Developer**: Tiaz Ahmed (@tiazahmd)
- **Project Specification**: Based on comprehensive SPEC.md requirements
- **Design Principles**: ADHD recovery-focused with clinical backing

---

*This changelog is maintained to provide transparency about project evolution and help developers understand the current state and planned direction of the Phoenix iOS app.* 