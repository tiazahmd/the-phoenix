import SwiftUI

// MARK: - Color System
extension Color {
    // Primary Purple Palette
    static let phoenixPrimary = Color(red: 0.39, green: 0.40, blue: 0.95) // #6366F1
    static let phoenixPrimaryLight = Color(red: 0.65, green: 0.71, blue: 0.99) // #A5B4FC
    static let phoenixPrimaryDark = Color(red: 0.26, green: 0.22, blue: 0.79) // #4338CA
    
    // Secondary Colors
    static let phoenixSuccess = Color(red: 0.06, green: 0.72, blue: 0.51) // #10B981
    static let phoenixWarning = Color(red: 0.96, green: 0.62, blue: 0.04) // #F59E0B
    static let phoenixDanger = Color(red: 0.94, green: 0.27, blue: 0.33) // #EF4444
    
    // Background Colors
    static let phoenixBackground = Color(red: 0.97, green: 0.98, blue: 0.99) // #F8FAFC
    static let phoenixCardBackground = Color.white
    static let phoenixSurfaceLight = Color(red: 0.95, green: 0.96, blue: 0.98) // #F1F5F9
    
    // Text Colors
    static let phoenixTextPrimary = Color(red: 0.02, green: 0.05, blue: 0.18) // #0F172A
    static let phoenixTextSecondary = Color(red: 0.39, green: 0.45, blue: 0.55) // #64748B
    static let phoenixTextTertiary = Color(red: 0.58, green: 0.63, blue: 0.71) // #94A3B8
    
    // Domain Colors for Quiz
    static let rdr2 = Color(red: 0.8, green: 0.4, blue: 0.2) // Brown/Orange
    static let cyberpunk = Color(red: 0.0, green: 0.8, blue: 0.8) // Cyan
    static let ghostOfTsushima = Color(red: 0.8, green: 0.2, blue: 0.2) // Red
    static let footballManager = Color(red: 0.2, green: 0.8, blue: 0.2) // Green
    static let techTrivia = Color(red: 0.4, green: 0.4, blue: 0.8) // Blue
    static let realMadrid = Color(red: 0.8, green: 0.8, blue: 0.8) // White/Silver
    static let historicalEvents = Color(red: 0.6, green: 0.4, blue: 0.2) // Brown
    static let sciFi = Color(red: 0.6, green: 0.2, blue: 0.8) // Purple
    static let sherlockHolmes = Color(red: 0.4, green: 0.6, blue: 0.2) // Olive
    static let guitarBasics = Color(red: 0.8, green: 0.6, blue: 0.2) // Orange
    static let harryPotter = Color(red: 0.8, green: 0.2, blue: 0.6) // Magenta
}

// MARK: - Typography
extension Font {
    // Duolingo-inspired typography scale
    static let phoenixTitle1 = Font.system(size: 32, weight: .bold, design: .rounded)
    static let phoenixTitle2 = Font.system(size: 28, weight: .bold, design: .rounded)
    static let phoenixTitle3 = Font.system(size: 24, weight: .semibold, design: .rounded)
    static let phoenixHeadline = Font.system(size: 20, weight: .semibold, design: .rounded)
    static let phoenixBody = Font.system(size: 16, weight: .medium, design: .rounded)
    static let phoenixBodySecondary = Font.system(size: 14, weight: .regular, design: .rounded)
    static let phoenixCaption = Font.system(size: 12, weight: .medium, design: .rounded)
}

// MARK: - Spacing
struct Spacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

// MARK: - Corner Radius
struct CornerRadius {
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let pill: CGFloat = 999
}

// MARK: - Shadows
struct PhoenixShadow {
    static let card = Shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
    static let button = Shadow(color: .phoenixPrimary.opacity(0.3), radius: 8, x: 0, y: 4)
    static let floating = Shadow(color: .black.opacity(0.12), radius: 16, x: 0, y: 8)
}

struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - Reusable Components

// Primary Button (Duolingo-style)
struct PhoenixButton: View {
    let title: String
    let action: () -> Void
    var style: ButtonStyle = .primary
    var size: ButtonSize = .large
    var isLoading: Bool = false
    var isDisabled: Bool = false
    
    enum ButtonStyle {
        case primary, secondary, success, warning, danger
        
        var backgroundColor: Color {
            switch self {
            case .primary: return .phoenixPrimary
            case .secondary: return .phoenixSurfaceLight
            case .success: return .phoenixSuccess
            case .warning: return .phoenixWarning
            case .danger: return .phoenixDanger
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .primary, .success, .warning, .danger: return .white
            case .secondary: return .phoenixTextPrimary
            }
        }
    }
    
    enum ButtonSize {
        case small, medium, large
        
        var padding: EdgeInsets {
            switch self {
            case .small: return EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
            case .medium: return EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20)
            case .large: return EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24)
            }
        }
        
        var font: Font {
            switch self {
            case .small: return .phoenixBodySecondary
            case .medium: return .phoenixBody
            case .large: return .phoenixHeadline
            }
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.sm) {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                        .tint(style.foregroundColor)
                }
                
                Text(title)
                    .font(size.font)
                    .fontWeight(.semibold)
            }
            .foregroundColor(style.foregroundColor)
            .padding(size.padding)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.md)
                    .fill(style.backgroundColor)
                    .opacity(isDisabled ? 0.6 : 1.0)
            )
            .scaleEffect(isDisabled ? 0.98 : 1.0)
        }
        .disabled(isDisabled || isLoading)
        .animation(.easeInOut(duration: 0.2), value: isDisabled)
        .animation(.easeInOut(duration: 0.2), value: isLoading)
    }
}

// Card Component (Duolingo-style)
struct PhoenixCard<Content: View>: View {
    let content: Content
    var padding: CGFloat = Spacing.lg
    var cornerRadius: CGFloat = CornerRadius.lg
    var shadow: Shadow = PhoenixShadow.card
    
    init(padding: CGFloat = Spacing.lg, cornerRadius: CGFloat = CornerRadius.lg, shadow: Shadow = PhoenixShadow.card, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.shadow = shadow
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.phoenixCardBackground)
                    .shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
            )
    }
}

// Progress Ring (Duolingo-style)
struct PhoenixProgressRing: View {
    let progress: Double
    let size: CGFloat
    var lineWidth: CGFloat = 8
    var color: Color = .phoenixPrimary
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    color,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1.0), value: progress)
        }
        .frame(width: size, height: size)
    }
}

// Streak Counter (Duolingo-style)
struct PhoenixStreakCounter: View {
    let count: Int
    let icon: String
    let title: String
    var color: Color = .phoenixPrimary
    
    var body: some View {
        VStack(spacing: Spacing.sm) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
            }
            
            Text("\(count)")
                .font(.phoenixTitle3)
                .foregroundColor(.phoenixTextPrimary)
            
            Text(title)
                .font(.phoenixCaption)
                .foregroundColor(.phoenixTextSecondary)
                .multilineTextAlignment(.center)
        }
    }
}

// Achievement Badge (Duolingo-style)
struct PhoenixBadge: View {
    let title: String
    let icon: String
    let isUnlocked: Bool
    var color: Color = .phoenixPrimary
    
    var body: some View {
        VStack(spacing: Spacing.sm) {
            ZStack {
                Circle()
                    .fill(isUnlocked ? color : Color.phoenixSurfaceLight)
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(isUnlocked ? .white : .phoenixTextTertiary)
            }
            
            Text(title)
                .font(.phoenixCaption)
                .foregroundColor(isUnlocked ? .phoenixTextPrimary : .phoenixTextTertiary)
                .multilineTextAlignment(.center)
        }
        .opacity(isUnlocked ? 1.0 : 0.6)
        .scaleEffect(isUnlocked ? 1.0 : 0.9)
        .animation(.easeInOut(duration: 0.3), value: isUnlocked)
    }
}

// Level Progress Bar (Duolingo-style)
struct PhoenixLevelProgress: View {
    let currentXP: Int
    let nextLevelXP: Int
    let level: Int
    
    private var progress: Double {
        Double(currentXP) / Double(nextLevelXP)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Text("Level \(level)")
                    .font(.phoenixHeadline)
                    .foregroundColor(.phoenixTextPrimary)
                
                Spacer()
                
                Text("\(currentXP) / \(nextLevelXP) XP")
                    .font(.phoenixBodySecondary)
                    .foregroundColor(.phoenixTextSecondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: CornerRadius.pill)
                        .fill(Color.phoenixSurfaceLight)
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: CornerRadius.pill)
                        .fill(
                            LinearGradient(
                                colors: [.phoenixPrimary, .phoenixPrimaryLight],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress, height: 8)
                        .animation(.easeInOut(duration: 1.0), value: progress)
                }
            }
            .frame(height: 8)
        }
    }
}

// Floating Action Button (Duolingo-style)
struct PhoenixFAB: View {
    let icon: String
    let action: () -> Void
    var color: Color = .phoenixPrimary
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(
                    Circle()
                        .fill(color)
                        .shadow(color: color.opacity(0.4), radius: 8, x: 0, y: 4)
                )
        }
        .scaleEffect(1.0)
        .animation(.easeInOut(duration: 0.2), value: color)
    }
} 