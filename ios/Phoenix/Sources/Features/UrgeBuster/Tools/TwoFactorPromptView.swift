import SwiftUI

struct TwoFactorPromptView: View {
    @State private var currentStep = 0
    @State private var responses: [String] = ["", ""]
    @State private var isCompleted = false
    
    private let prompts = [
        "What am I feeling right now?",
        "What would happen if I wait 10 minutes?"
    ]
    
    private let placeholders = [
        "Describe your current emotions...",
        "Think about the consequences of waiting..."
    ]
    
    var body: some View {
        PhoenixCard {
            VStack(spacing: Spacing.xl) {
                VStack(spacing: Spacing.md) {
                    Text("Two-Factor Check")
                        .font(.phoenixTitle3)
                        .foregroundColor(.phoenixTextPrimary)
                    
                    Text("Pause and reflect before making any decisions")
                        .font(.phoenixBody)
                        .foregroundColor(.phoenixTextSecondary)
                        .multilineTextAlignment(.center)
                }
                
                if !isCompleted {
                    // Progress Indicator
                    HStack(spacing: Spacing.sm) {
                        ForEach(0..<prompts.count, id: \.self) { index in
                            Circle()
                                .fill(index <= currentStep ? Color.phoenixWarning : Color.phoenixSurfaceLight)
                                .frame(width: 12, height: 12)
                                .animation(.easeInOut(duration: 0.3), value: currentStep)
                        }
                    }
                    
                    // Current Prompt
                    VStack(spacing: Spacing.lg) {
                        Text("Step \(currentStep + 1) of \(prompts.count)")
                            .font(.phoenixCaption)
                            .foregroundColor(.phoenixTextSecondary)
                        
                        Text(prompts[currentStep])
                            .font(.phoenixHeadline)
                            .foregroundColor(.phoenixTextPrimary)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                        
                        // Text Input
                        VStack(alignment: .leading, spacing: Spacing.sm) {
                            TextEditor(text: $responses[currentStep])
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
                                .frame(height: 120)
                            
                            if responses[currentStep].isEmpty {
                                Text(placeholders[currentStep])
                                    .font(.phoenixBody)
                                    .foregroundColor(.phoenixTextTertiary)
                                    .padding(.horizontal, Spacing.md)
                                    .allowsHitTesting(false)
                            }
                        }
                    }
                    
                    // Navigation Buttons
                    HStack(spacing: Spacing.md) {
                        if currentStep > 0 {
                            PhoenixButton(
                                title: "Back",
                                action: previousStep,
                                style: .secondary
                            )
                        }
                        
                        PhoenixButton(
                            title: currentStep == prompts.count - 1 ? "Complete" : "Next",
                            action: nextStep,
                            isDisabled: responses[currentStep].trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        )
                    }
                } else {
                    // Completion View
                    VStack(spacing: Spacing.lg) {
                        Text("🤔 Reflection Complete")
                            .font(.phoenixHeadline)
                            .foregroundColor(.phoenixWarning)
                            .fontWeight(.bold)
                        
                        Text("You've taken time to reflect. How do you feel about your situation now?")
                            .font(.phoenixBody)
                            .foregroundColor(.phoenixTextSecondary)
                            .multilineTextAlignment(.center)
                        
                        VStack(alignment: .leading, spacing: Spacing.md) {
                            ForEach(0..<prompts.count, id: \.self) { index in
                                VStack(alignment: .leading, spacing: Spacing.xs) {
                                    Text(prompts[index])
                                        .font(.phoenixBodySecondary)
                                        .foregroundColor(.phoenixTextSecondary)
                                        .fontWeight(.semibold)
                                    
                                    Text(responses[index])
                                        .font(.phoenixBody)
                                        .foregroundColor(.phoenixTextPrimary)
                                        .padding(Spacing.sm)
                                        .background(
                                            RoundedRectangle(cornerRadius: CornerRadius.sm)
                                                .fill(Color.phoenixSurfaceLight)
                                        )
                                }
                            }
                        }
                        
                        PhoenixButton(
                            title: "Start Over",
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
    
    private func nextStep() {
        if currentStep < prompts.count - 1 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentStep += 1
            }
        } else {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isCompleted = true
            }
            
            // Success haptic feedback
            let notificationFeedback = UINotificationFeedbackGenerator()
            notificationFeedback.notificationOccurred(.success)
        }
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    private func previousStep() {
        if currentStep > 0 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentStep -= 1
            }
        }
    }
    
    private func resetReflection() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentStep = 0
            responses = ["", ""]
            isCompleted = false
        }
    }
}

#Preview {
    TwoFactorPromptView()
} 