import SwiftUI

struct ColdWaterTimerView: View {
    @State private var timeRemaining = 30
    @State private var isActive = false
    @State private var isCompleted = false
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        PhoenixCard {
            VStack(spacing: Spacing.xl) {
                VStack(spacing: Spacing.md) {
                    Text("Cold Water Timer")
                        .font(.phoenixTitle3)
                        .foregroundColor(.phoenixTextPrimary)
                    
                    Text("Take deep breaths and focus on the present moment")
                        .font(.phoenixBody)
                        .foregroundColor(.phoenixTextSecondary)
                        .multilineTextAlignment(.center)
                }
                
                // Timer Display
                ZStack {
                    Circle()
                        .stroke(Color.phoenixSurfaceLight, lineWidth: 8)
                        .frame(width: 200, height: 200)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(30 - timeRemaining) / 30)
                        .stroke(
                            LinearGradient(
                                colors: [.phoenixSuccess, .phoenixPrimary],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 1), value: timeRemaining)
                    
                    VStack(spacing: Spacing.xs) {
                        Text("\(timeRemaining)")
                            .font(.phoenixTitle1)
                            .foregroundColor(.phoenixTextPrimary)
                            .fontWeight(.bold)
                        
                        Text("seconds")
                            .font(.phoenixCaption)
                            .foregroundColor(.phoenixTextSecondary)
                    }
                }
                
                if isCompleted {
                    VStack(spacing: Spacing.sm) {
                        Text("🌊 Well Done!")
                            .font(.phoenixHeadline)
                            .foregroundColor(.phoenixSuccess)
                            .fontWeight(.bold)
                        
                        Text("You've completed the breathing exercise. How do you feel?")
                            .font(.phoenixBody)
                            .foregroundColor(.phoenixTextSecondary)
                            .multilineTextAlignment(.center)
                    }
                } else {
                    VStack(spacing: Spacing.md) {
                        Text(isActive ? "Breathe deeply and slowly" : "Tap start when ready")
                            .font(.phoenixBody)
                            .foregroundColor(.phoenixTextSecondary)
                            .multilineTextAlignment(.center)
                        
                        PhoenixButton(
                            title: isActive ? "Pause" : "Start",
                            action: toggleTimer,
                            style: isActive ? .secondary : .primary
                        )
                    }
                }
                
                if isCompleted {
                    PhoenixButton(
                        title: "Reset",
                        action: resetTimer,
                        style: .secondary
                    )
                }
            }
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.top, Spacing.lg)
        .onReceive(timer) { _ in
            if isActive && timeRemaining > 0 {
                timeRemaining -= 1
                
                if timeRemaining == 0 {
                    isActive = false
                    isCompleted = true
                    
                    // Success haptic feedback
                    let notificationFeedback = UINotificationFeedbackGenerator()
                    notificationFeedback.notificationOccurred(.success)
                }
            }
        }
    }
    
    private func toggleTimer() {
        isActive.toggle()
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    private func resetTimer() {
        timeRemaining = 30
        isActive = false
        isCompleted = false
    }
}

#Preview {
    ColdWaterTimerView()
} 