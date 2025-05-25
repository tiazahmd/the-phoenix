import SwiftUI

struct SafetyCheckView: View {
    @State private var checkedItems: Set<Int> = []
    @State private var isCompleted = false
    
    private let safetyItems = [
        SafetyItem(
            title: "I am in a safe physical environment",
            description: "Away from triggers and harmful situations",
            icon: "house.fill"
        ),
        SafetyItem(
            title: "I have someone I can contact if needed",
            description: "Friend, family, or support person available",
            icon: "person.2.fill"
        ),
        SafetyItem(
            title: "I am not under the influence",
            description: "Clear-minded and able to make good decisions",
            icon: "brain.head.profile"
        ),
        SafetyItem(
            title: "I have healthy coping tools available",
            description: "Alternative activities or resources nearby",
            icon: "heart.fill"
        )
    ]
    
    private var allItemsChecked: Bool {
        checkedItems.count == safetyItems.count
    }
    
    var body: some View {
        PhoenixCard {
            VStack(spacing: Spacing.xl) {
                VStack(spacing: Spacing.md) {
                    Text("Safety Check")
                        .font(.phoenixTitle3)
                        .foregroundColor(.phoenixTextPrimary)
                    
                    Text("Verify your environment and emotional state")
                        .font(.phoenixBody)
                        .foregroundColor(.phoenixTextSecondary)
                        .multilineTextAlignment(.center)
                }
                
                if !isCompleted {
                    VStack(spacing: Spacing.lg) {
                        Text("Check all that apply to your current situation:")
                            .font(.phoenixBody)
                            .foregroundColor(.phoenixTextPrimary)
                            .multilineTextAlignment(.center)
                        
                        VStack(spacing: Spacing.md) {
                            ForEach(Array(safetyItems.enumerated()), id: \.offset) { index, item in
                                SafetyCheckItem(
                                    item: item,
                                    isChecked: checkedItems.contains(index)
                                ) {
                                    toggleItem(index)
                                }
                            }
                        }
                        
                        if allItemsChecked {
                            PhoenixButton(
                                title: "Complete Safety Check",
                                action: completeCheck,
                                style: .success
                            )
                        } else {
                            VStack(spacing: Spacing.sm) {
                                Text("Check \(safetyItems.count - checkedItems.count) more item(s)")
                                    .font(.phoenixBodySecondary)
                                    .foregroundColor(.phoenixTextSecondary)
                                
                                PhoenixButton(
                                    title: "I Need Help",
                                    action: requestHelp,
                                    style: .danger
                                )
                            }
                        }
                    }
                } else {
                    // Completion View
                    VStack(spacing: Spacing.lg) {
                        Text("✅ Safety Verified")
                            .font(.phoenixHeadline)
                            .foregroundColor(.phoenixSuccess)
                            .fontWeight(.bold)
                        
                        Text("You're in a safe environment and have the resources you need. You're ready to handle this situation.")
                            .font(.phoenixBody)
                            .foregroundColor(.phoenixTextSecondary)
                            .multilineTextAlignment(.center)
                        
                        VStack(spacing: Spacing.md) {
                            Text("Remember:")
                                .font(.phoenixBodySecondary)
                                .foregroundColor(.phoenixTextSecondary)
                                .fontWeight(.semibold)
                            
                            VStack(alignment: .leading, spacing: Spacing.xs) {
                                Text("• You have the strength to overcome this moment")
                                Text("• This feeling is temporary and will pass")
                                Text("• You've made it through difficult times before")
                                Text("• Reaching out for help is a sign of strength")
                            }
                            .font(.phoenixBody)
                            .foregroundColor(.phoenixTextPrimary)
                        }
                        
                        PhoenixButton(
                            title: "Check Again",
                            action: resetCheck,
                            style: .secondary
                        )
                    }
                }
            }
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.top, Spacing.lg)
    }
    
    private func toggleItem(_ index: Int) {
        withAnimation(.easeInOut(duration: 0.2)) {
            if checkedItems.contains(index) {
                checkedItems.remove(index)
            } else {
                checkedItems.insert(index)
            }
        }
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    private func completeCheck() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            isCompleted = true
        }
        
        // Success haptic feedback
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.success)
    }
    
    private func requestHelp() {
        // TODO: Implement emergency contact or crisis helpline
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.warning)
    }
    
    private func resetCheck() {
        withAnimation(.easeInOut(duration: 0.3)) {
            checkedItems.removeAll()
            isCompleted = false
        }
    }
}

struct SafetyItem {
    let title: String
    let description: String
    let icon: String
}

struct SafetyCheckItem: View {
    let item: SafetyItem
    let isChecked: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.md) {
                Image(systemName: item.icon)
                    .font(.title3)
                    .foregroundColor(isChecked ? .phoenixSuccess : .phoenixTextSecondary)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(item.title)
                        .font(.phoenixBody)
                        .foregroundColor(.phoenixTextPrimary)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.leading)
                    
                    Text(item.description)
                        .font(.phoenixCaption)
                        .foregroundColor(.phoenixTextSecondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isChecked ? .phoenixSuccess : .phoenixTextTertiary)
            }
            .padding(Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.md)
                    .fill(isChecked ? Color.phoenixSuccess.opacity(0.1) : Color.phoenixSurfaceLight)
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.md)
                            .stroke(isChecked ? Color.phoenixSuccess : Color.phoenixBorder, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SafetyCheckView()
} 