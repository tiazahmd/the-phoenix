import SwiftUI

struct MemoryFlashbackView: View {
    @State private var selectedMemoryType: MemoryType?
    @State private var memoryText = ""
    @State private var isReflecting = false
    @State private var isCompleted = false
    
    private let memoryTypes = MemoryType.allCases
    
    var body: some View {
        PhoenixCard {
            VStack(spacing: Spacing.xl) {
                VStack(spacing: Spacing.md) {
                    Text("Memory Flashback")
                        .font(.phoenixTitle3)
                        .foregroundColor(.phoenixTextPrimary)
                    
                    Text("Reconnect with positive memories and motivations")
                        .font(.phoenixBody)
                        .foregroundColor(.phoenixTextSecondary)
                        .multilineTextAlignment(.center)
                }
                
                if !isReflecting && !isCompleted {
                    // Memory Type Selection
                    VStack(spacing: Spacing.lg) {
                        Text("What kind of positive memory would you like to recall?")
                            .font(.phoenixBody)
                            .foregroundColor(.phoenixTextPrimary)
                            .multilineTextAlignment(.center)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: Spacing.md) {
                            ForEach(memoryTypes) { memoryType in
                                MemoryTypeCard(
                                    memoryType: memoryType,
                                    isSelected: selectedMemoryType == memoryType
                                ) {
                                    selectedMemoryType = memoryType
                                    startReflection()
                                }
                            }
                        }
                    }
                } else if isReflecting && !isCompleted {
                    // Memory Reflection
                    VStack(spacing: Spacing.lg) {
                        if let memoryType = selectedMemoryType {
                            VStack(spacing: Spacing.md) {
                                Text(memoryType.emoji)
                                    .font(.system(size: 60))
                                
                                Text(memoryType.prompt)
                                    .font(.phoenixHeadline)
                                    .foregroundColor(.phoenixTextPrimary)
                                    .fontWeight(.semibold)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: Spacing.sm) {
                            Text("Describe this memory in detail:")
                                .font(.phoenixBodySecondary)
                                .foregroundColor(.phoenixTextSecondary)
                                .fontWeight(.semibold)
                            
                            TextEditor(text: $memoryText)
                                .font(.phoenixBody)
                                .foregroundColor(.phoenixTextPrimary)
                                .padding(Spacing.md)
                                .background(
                                    RoundedRectangle(cornerRadius: CornerRadius.md)
                                        .fill(Color.phoenixSurfaceLight)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: CornerRadius.md)
                                                .stroke(Color.phoenixBorder, lineWidth: 1)
                                        )
                                )
                                .frame(height: 150)
                            
                            if memoryText.isEmpty {
                                Text("What did you see, hear, feel? Who was there? What made it special?")
                                    .font(.phoenixCaption)
                                    .foregroundColor(.phoenixTextTertiary)
                                    .padding(.horizontal, Spacing.md)
                                    .allowsHitTesting(false)
                            }
                        }
                        
                        HStack(spacing: Spacing.md) {
                            PhoenixButton(
                                title: "Back",
                                action: goBack,
                                style: .secondary
                            )
                            
                            PhoenixButton(
                                title: "Complete",
                                action: completeReflection,
                                isDisabled: memoryText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                            )
                        }
                    }
                } else if isCompleted {
                    // Completion View
                    VStack(spacing: Spacing.lg) {
                        if let memoryType = selectedMemoryType {
                            Text(memoryType.emoji)
                                .font(.system(size: 80))
                        }
                        
                        Text("💝 Beautiful Memory")
                            .font(.phoenixHeadline)
                            .foregroundColor(.phoenixPrimaryLight)
                            .fontWeight(.bold)
                        
                        Text("You've reconnected with something beautiful and meaningful. Hold onto this feeling.")
                            .font(.phoenixBody)
                            .foregroundColor(.phoenixTextSecondary)
                            .multilineTextAlignment(.center)
                        
                        if !memoryText.isEmpty {
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("Your Memory:")
                                    .font(.phoenixBodySecondary)
                                    .foregroundColor(.phoenixTextSecondary)
                                    .fontWeight(.semibold)
                                
                                Text(memoryText)
                                    .font(.phoenixBody)
                                    .foregroundColor(.phoenixTextPrimary)
                                    .padding(Spacing.md)
                                    .background(
                                        RoundedRectangle(cornerRadius: CornerRadius.md)
                                            .fill(Color.phoenixPrimaryLight.opacity(0.1))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: CornerRadius.md)
                                                    .stroke(Color.phoenixPrimaryLight.opacity(0.3), lineWidth: 1)
                                            )
                                    )
                            }
                        }
                        
                        VStack(spacing: Spacing.sm) {
                            Text("Remember:")
                                .font(.phoenixBodySecondary)
                                .foregroundColor(.phoenixTextSecondary)
                                .fontWeight(.semibold)
                            
                            Text("This memory is part of who you are. You have the capacity for joy, love, and meaningful experiences.")
                                .font(.phoenixBody)
                                .foregroundColor(.phoenixTextPrimary)
                                .multilineTextAlignment(.center)
                        }
                        
                        PhoenixButton(
                            title: "Reflect on Another Memory",
                            action: resetReflection,
                            style: .secondary
                        )
                    }
                }
            }
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.top, Spacing.lg)
    }
    
    private func startReflection() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isReflecting = true
        }
    }
    
    private func goBack() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isReflecting = false
            selectedMemoryType = nil
            memoryText = ""
        }
    }
    
    private func completeReflection() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            isCompleted = true
        }
        
        // Success haptic feedback
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.success)
    }
    
    private func resetReflection() {
        withAnimation(.easeInOut(duration: 0.3)) {
            selectedMemoryType = nil
            memoryText = ""
            isReflecting = false
            isCompleted = false
        }
    }
}

enum MemoryType: String, CaseIterable, Identifiable {
    case achievement = "achievement"
    case love = "love"
    case adventure = "adventure"
    case peace = "peace"
    case growth = "growth"
    case connection = "connection"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .achievement: return "Achievement"
        case .love: return "Love"
        case .adventure: return "Adventure"
        case .peace: return "Peace"
        case .growth: return "Growth"
        case .connection: return "Connection"
        }
    }
    
    var emoji: String {
        switch self {
        case .achievement: return "🏆"
        case .love: return "❤️"
        case .adventure: return "🌟"
        case .peace: return "🕊️"
        case .growth: return "🌱"
        case .connection: return "🤝"
        }
    }
    
    var prompt: String {
        switch self {
        case .achievement: return "Think of a time you accomplished something you're proud of"
        case .love: return "Recall a moment when you felt deeply loved or loving"
        case .adventure: return "Remember an exciting experience or adventure"
        case .peace: return "Think of a time when you felt completely at peace"
        case .growth: return "Recall when you overcame a challenge and grew stronger"
        case .connection: return "Remember a meaningful connection with someone"
        }
    }
    
    var color: Color {
        switch self {
        case .achievement: return .phoenixWarning
        case .love: return .phoenixDanger
        case .adventure: return .phoenixPrimary
        case .peace: return .phoenixSuccess
        case .growth: return .phoenixPrimaryLight
        case .connection: return .phoenixPrimaryDark
        }
    }
}

struct MemoryTypeCard: View {
    let memoryType: MemoryType
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.md) {
                Text(memoryType.emoji)
                    .font(.system(size: 40))
                
                Text(memoryType.title)
                    .font(.phoenixHeadline)
                    .foregroundColor(.phoenixTextPrimary)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
            }
            .padding(Spacing.lg)
            .frame(height: 120)
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.lg)
                    .fill(isSelected ? memoryType.color.opacity(0.2) : Color.phoenixCardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.lg)
                            .stroke(isSelected ? memoryType.color : Color.phoenixBorder, lineWidth: isSelected ? 2 : 1)
                    )
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

#Preview {
    MemoryFlashbackView()
} 