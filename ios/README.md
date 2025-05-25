# Phoenix iOS App

A personal development and mindfulness application built with SwiftUI.

## Features

- Daily check-ins and mood tracking
- Guided exercises and meditations
- Journal entries with mood analysis
- Progress tracking and insights
- Achievement system
- Personalized recommendations
- Dark mode support
- Offline capabilities

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+
- SwiftLint (for code style enforcement)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/phoenix.git
cd phoenix/ios
```

2. Install dependencies:
```bash
brew install xcodegen
brew install swiftlint
```

3. Generate Xcode project:
```bash
xcodegen generate
```

4. Open the project:
```bash
open Phoenix.xcodeproj
```

## Project Structure

```
Phoenix/
├── Sources/
│   ├── App/              # App entry point and configuration
│   ├── Features/         # Main feature modules
│   │   ├── Dashboard/    # User dashboard
│   │   ├── Exercises/    # Guided exercises
│   │   ├── Journal/      # Journaling feature
│   │   └── Profile/      # User profile
│   ├── Core/             # Core functionality
│   ├── UI/               # Reusable UI components
│   ├── Services/         # Network and data services
│   └── Utils/            # Utility functions
├── Resources/            # Assets and resources
├── Tests/               # Unit and UI tests
└── Configuration/       # Project configuration files
```

## Architecture

- SwiftUI for UI
- MVVM architecture
- Combine for reactive programming
- Core Data for local storage
- Swift Package Manager for dependencies

## Code Style

We use SwiftLint to enforce code style. Configuration can be found in `.swiftlint.yml`.

## Testing

- Unit tests for business logic
- UI tests for critical user flows
- Snapshot tests for UI components

## Contributing

1. Create a feature branch
2. Make your changes
3. Run tests and ensure they pass
4. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details. 