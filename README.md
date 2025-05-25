# The Phoenix 🔥

> *"A phoenix rises from the ashes, stronger than before."*

**The Phoenix** is a comprehensive ADHD-focused recovery app designed to provide personalized support, tools, and insights for individuals on their recovery journey. Built with modern technologies and a focus on user experience, The Phoenix combines evidence-based recovery techniques with engaging gamification elements.

## 🚀 Build Status

**Production Ready** - The Phoenix is fully functional and ready for deployment.

### ✅ Current Build Status
- **iOS App**: ✅ BUILD SUCCEEDED (iPhone 16, iOS 18.4)
- **Django Backend**: ✅ System check passed (0 issues)
- **Code Quality**: ✅ All critical compilation errors resolved
- **SwiftLint**: ⚠️ 91 minor style warnings (non-blocking)
- **Architecture**: ✅ All files under 300-line limit enforced
- **Tests**: ✅ Backend tests passing

## 🌟 Features

### 🎯 **Core Features**
- **Daily Check-ins**: Track mood, energy, focus, and recovery progress
- **Interactive Quizzes**: Knowledge-based quizzes across multiple domains (Tech, Sports, History, etc.)
- **Urge Buster Tools**: Crisis intervention tools including puzzles, timers, and reflection exercises
- **Recovery Dashboard**: Comprehensive analytics and progress visualization
- **Tips & Insights**: Curated recovery tips and motivational content

### 🛡️ **Urge Buster Tools**
- **Quick Puzzle**: Sliding puzzle game for mental distraction
- **Cold Water Timer**: 30-second guided breathing exercise
- **Two-Factor Check**: Reflection prompts before making decisions
- **Safety Check**: Environmental and emotional safety verification
- **Memory Flashback**: Positive memory and motivation reconnection

### 📊 **Analytics & Insights**
- Progress tracking with beautiful visualizations
- Mood and energy pattern analysis
- Quiz performance metrics
- Recovery milestone celebrations

## 🏗️ Architecture

### **iOS App (SwiftUI)**
- **Language**: Swift 5.9
- **Framework**: SwiftUI 5.0
- **Minimum iOS**: 17.0
- **Architecture**: MVVM with Combine
- **Design System**: Custom Phoenix design language with Duolingo-inspired purple theming

### **Backend (Django)**
- **Language**: Python 3.12
- **Framework**: Django 5.0
- **API**: Django REST Framework 3.14
- **Database**: PostgreSQL 16
- **Authentication**: Simple username/password system

### **Key Technologies**
- **iOS**: SwiftUI, Combine, Core Data, Charts framework
- **Backend**: Django, DRF, PostgreSQL
- **Design**: Custom design system with accessibility support
- **State Management**: Combine with @StateObject and @ObservableObject

## 🚀 Getting Started

### Prerequisites
- **iOS Development**: Xcode 15.0+, iOS 17.0+
- **Backend Development**: Python 3.12+, PostgreSQL 16+

### Backend Setup

1. **Clone and navigate to backend**:
   ```bash
   git clone <repository-url>
   cd the-phoenix/backend
   ```

2. **Create virtual environment**:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

4. **Database setup**:
   ```bash
   python manage.py migrate
   python manage.py createsuperuser
   ```

5. **Run development server**:
   ```bash
   python manage.py runserver
   ```

### iOS Setup

1. **Open Xcode project**:
   ```bash
   cd ios
   open Phoenix.xcodeproj
   ```

2. **Configure signing**: Update the team and bundle identifier in Xcode

3. **Build and run**: Select your target device and press ⌘+R

## 📱 App Structure

### **Core Components**
```
ios/Phoenix/Sources/
├── App/                    # App entry point and main navigation
├── Core/                   # Shared utilities and design system
│   ├── Design/            # Design system, colors, typography
│   ├── Network/           # API client and networking
│   └── Storage/           # Core Data models and persistence
└── Features/              # Feature modules
    ├── Authentication/    # Login and user management
    ├── CheckIn/          # Daily check-in functionality
    ├── Dashboard/        # Analytics and progress tracking
    ├── Quiz/             # Interactive quiz system
    ├── Tips/             # Recovery tips and insights
    └── UrgeBuster/       # Crisis intervention tools
```

### **Backend Structure**
```
backend/
├── core/                  # Django project settings
├── apps/                  # Django applications
│   ├── authentication/   # User management
│   ├── checkins/         # Check-in data models
│   ├── quizzes/          # Quiz system
│   └── tips/             # Tips and content management
└── requirements.txt       # Python dependencies
```

## 🎨 Design System

The Phoenix uses a custom design system inspired by Duolingo's engaging interface:

- **Primary Color**: Phoenix Purple (#6366F1)
- **Typography**: SF Pro with custom Phoenix font styles
- **Components**: Reusable SwiftUI components with consistent spacing and styling
- **Accessibility**: Full support for Dynamic Type, VoiceOver, and high contrast modes

## 🧪 Testing

### iOS Testing
```bash
cd ios
xcodebuild test -scheme Phoenix -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.4'
```

### Backend Testing
```bash
cd backend
python manage.py test
```

## 📊 Code Quality

- **SwiftLint**: Enforced code style and best practices
- **Line Limit**: Maximum 300 lines per file (enforced through refactoring)
- **Architecture**: Clean separation of concerns with MVVM pattern
- **Documentation**: Comprehensive inline documentation and README

## 🔧 Development Guidelines

### **Code Organization**
- Files are organized by feature with clear separation of concerns
- Maximum 300 lines per file (automatically enforced)
- Consistent naming conventions across the codebase
- Comprehensive error handling and user feedback

### **UI/UX Principles**
- iOS 16 design guidelines compliance
- Responsive design for all device sizes
- Dark/light mode support
- Accessibility-first approach

### **Performance**
- Lazy loading for large data sets
- Efficient Core Data usage
- Optimized network requests with caching
- Smooth animations and transitions

## 🚀 Deployment

### **iOS App Store**
1. Archive the app in Xcode
2. Upload to App Store Connect
3. Submit for review

### **Backend Deployment**
The backend is designed for simple deployment:
- Django production settings
- PostgreSQL database
- Environment variable configuration

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Design Inspiration**: Duolingo's engaging and accessible interface design
- **Recovery Framework**: Evidence-based addiction recovery methodologies
- **Community**: The ADHD and recovery communities for insights and feedback

---

**The Phoenix** - Rising stronger from the ashes of addiction. 🔥✨ 