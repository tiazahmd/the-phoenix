import SwiftUI

// MARK: - UrgeBuster Supporting Views

// MARK: - Supporting Views

// MARK: - Tool Detail View

struct UrgeBusterToolDetailView: View {
    let tool: UrgeBusterTool
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: Spacing.md) {
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundColor(.phoenixPrimary)
                    }
                    
                    Spacer()
                    
                    Text(tool.title)
                        .font(.phoenixHeadline)
                        .foregroundColor(.phoenixTextPrimary)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    // Placeholder for symmetry
                    Color.clear
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.top, Spacing.md)
            
            // Tool Content
            Group {
                switch tool {
                case .quickPuzzle:
                    QuickPuzzleView()
                case .coldWaterTimer:
                    ColdWaterTimerView()
                case .twoFactorPrompt:
                    TwoFactorPromptView()
                case .safetyCheck:
                    SafetyCheckView()
                case .memoryFlashback:
                    MemoryFlashbackView()
                }
            }
            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
        }
        .background(Color.phoenixBackground)
    }
}

// MARK: - Main View

struct UrgeBusterMainView: View {
    let tools: [UrgeBusterTool]
    let animateCards: Bool
    let onToolSelected: (UrgeBusterTool) -> Void
    let onEmergencyContact: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xl) {
                // Header
                VStack(spacing: Spacing.lg) {
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [.phoenixWarning.opacity(0.3), .clear],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 80
                                )
                            )
                            .frame(width: 160, height: 160)
                        
                        Image(systemName: "shield.lefthalf.filled")
                            .font(.system(size: 80, weight: .light))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.phoenixWarning, .phoenixDanger],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: .phoenixWarning.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    
                    VStack(spacing: Spacing.sm) {
                        Text("Urge Buster")
                            .font(.phoenixTitle1)
                            .foregroundColor(.phoenixTextPrimary)
                        
                        Text("Quick tools to help you through difficult moments")
                            .font(.phoenixBody)
                            .foregroundColor(.phoenixTextSecondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.top, Spacing.lg)
                
                // Emergency Button
                PhoenixCard(shadow: PhoenixShadow.floating) {
                    VStack(spacing: Spacing.md) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.title2)
                                .foregroundColor(.phoenixDanger)
                            
                            VStack(alignment: .leading, spacing: Spacing.xs) {
                                Text("Need immediate help?")
                                    .font(.phoenixHeadline)
                                    .foregroundColor(.phoenixTextPrimary)
                                    .fontWeight(.semibold)
                                
                                Text("Tap for emergency support")
                                    .font(.phoenixBodySecondary)
                                    .foregroundColor(.phoenixTextSecondary)
                            }
                            
                            Spacer()
                        }
                        
                        PhoenixButton(
                            title: "Emergency Contact",
                            action: onEmergencyContact,
                            style: .danger
                        )
                    }
                }
                .padding(.horizontal, Spacing.lg)
                .opacity(animateCards ? 1.0 : 0.0)
                .offset(y: animateCards ? 0 : 30)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: animateCards)
                
                // Tools Section
                VStack(alignment: .leading, spacing: Spacing.md) {
                    Text("Choose a Tool")
                        .font(.phoenixTitle3)
                        .foregroundColor(.phoenixTextPrimary)
                        .padding(.horizontal, Spacing.lg)
                        .opacity(animateCards ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 0.5).delay(0.3), value: animateCards)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: Spacing.lg) {
                        ForEach(Array(tools.enumerated()), id: \.element) { index, tool in
                            UrgeBusterToolCard(tool: tool) {
                                onToolSelected(tool)
                            }
                            .opacity(animateCards ? 1.0 : 0.0)
                            .offset(y: animateCards ? 0 : 50)
                            .animation(
                                .spring(response: 0.6, dampingFraction: 0.8)
                                .delay(0.4 + Double(index) * 0.1),
                                value: animateCards
                            )
                        }
                    }
                    .padding(.horizontal, Spacing.lg)
                }
                
                Spacer(minLength: 100)
            }
            .padding(.vertical, Spacing.md)
        }
    }
}

// MARK: - Tool Card

struct UrgeBusterToolCard: View {
    let tool: UrgeBusterTool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.md) {
                ZStack {
                    Circle()
                        .fill(tool.color.opacity(0.2))
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: tool.icon)
                        .font(.title)
                        .foregroundColor(tool.color)
                }
                
                VStack(spacing: Spacing.xs) {
                    Text(tool.title)
                        .font(.phoenixHeadline)
                        .foregroundColor(.phoenixTextPrimary)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    
                    Text(tool.description)
                        .font(.phoenixCaption)
                        .foregroundColor(.phoenixTextSecondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                }
            }
            .padding(Spacing.lg)
            .frame(height: 160)
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.lg)
                    .fill(Color.phoenixCardBackground)
                    .shadow(color: tool.color.opacity(0.2), radius: 8, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.lg)
                    .stroke(tool.color.opacity(0.3), lineWidth: 1)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

// MARK: - Preview

#Preview {
    UrgeBusterView()
        .environmentObject(AuthenticationManager())
} 