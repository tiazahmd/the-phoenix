import SwiftUI

// MARK: - UrgeBusterTool Enum

enum UrgeBusterTool: String, CaseIterable, Identifiable {
    case quickPuzzle = "quick_puzzle"
    case coldWaterTimer = "cold_water_timer"
    case twoFactorPrompt = "two_factor_prompt"
    case safetyCheck = "safety_check"
    case memoryFlashback = "memory_flashback"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .quickPuzzle: return "Quick Puzzle"
        case .coldWaterTimer: return "Cold Water Timer"
        case .twoFactorPrompt: return "Two-Factor Check"
        case .safetyCheck: return "Safety Check"
        case .memoryFlashback: return "Memory Flashback"
        }
    }
    
    var description: String {
        switch self {
        case .quickPuzzle: return "Focus your mind with a sliding puzzle"
        case .coldWaterTimer: return "30-second breathing exercise"
        case .twoFactorPrompt: return "Pause and reflect before acting"
        case .safetyCheck: return "Verify your environment and emotions"
        case .memoryFlashback: return "Reconnect with positive memories"
        }
    }
    
    var icon: String {
        switch self {
        case .quickPuzzle: return "puzzlepiece.fill"
        case .coldWaterTimer: return "timer"
        case .twoFactorPrompt: return "questionmark.circle.fill"
        case .safetyCheck: return "checkmark.shield.fill"
        case .memoryFlashback: return "heart.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .quickPuzzle: return .phoenixPrimary
        case .coldWaterTimer: return .phoenixSuccess
        case .twoFactorPrompt: return .phoenixWarning
        case .safetyCheck: return .phoenixDanger
        case .memoryFlashback: return .phoenixPrimaryLight
        }
    }
}

// MARK: - Main UrgeBuster View
struct UrgeBusterView: View {
    @State private var selectedTool: UrgeBusterTool?
    @State private var showingEmergencyContact = false
    @State private var animateCards = false
    
    private let tools = UrgeBusterTool.allCases
    
    var body: some View {
        ZStack {
            Color.phoenixBackground.ignoresSafeArea()
            
            if let selectedTool = selectedTool {
                UrgeBusterToolDetailView(tool: selectedTool) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        self.selectedTool = nil
                    }
                }
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            } else {
                UrgeBusterMainView(
                    tools: tools,
                    animateCards: animateCards,
                    onToolSelected: { tool in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTool = tool
                        }
                    },
                    onEmergencyContact: {
                        showingEmergencyContact = true
                    }
                )
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).delay(0.2)) {
                animateCards = true
            }
        }
        .alert("Emergency Contact", isPresented: $showingEmergencyContact) {
            Button("Call Now") {
                // TODO: Implement emergency contact calling
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This would call your emergency contact or crisis helpline.")
        }
    }
}

// MARK: - Supporting Views

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
                    Text("Quick Puzzle Tool")
                        .font(.phoenixTitle2)
                        .foregroundColor(.phoenixTextPrimary)
                        .padding()
                case .coldWaterTimer:
                    Text("Cold Water Timer Tool")
                        .font(.phoenixTitle2)
                        .foregroundColor(.phoenixTextPrimary)
                        .padding()
                case .twoFactorPrompt:
                    Text("Two-Factor Prompt Tool")
                        .font(.phoenixTitle2)
                        .foregroundColor(.phoenixTextPrimary)
                        .padding()
                case .safetyCheck:
                    Text("Safety Check Tool")
                        .font(.phoenixTitle2)
                        .foregroundColor(.phoenixTextPrimary)
                        .padding()
                case .memoryFlashback:
                    Text("Memory Flashback Tool")
                        .font(.phoenixTitle2)
                        .foregroundColor(.phoenixTextPrimary)
                        .padding()
                }
            }
            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
        }
        .background(Color.phoenixBackground)
    }
}

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