import SwiftUI

struct CheckInView: View {
    @EnvironmentObject private var coreDataStack: CoreDataStack
    @State private var currentStep = 0
    @State private var moodLevel: Double = 5
    @State private var urgeLevel: Double = 1
    @State private var triggerContext = ""
    @State private var note = ""
    @State private var showingQuickActions = false
    @State private var isSubmitting = false
    @State private var showingSuccess = false
    
    private let totalSteps = 4
    
    var body: some View {
        ZStack {
            Color.phoenixBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress Header
                VStack(spacing: Spacing.lg) {
                    // Progress Bar
                    VStack(spacing: Spacing.sm) {
                        HStack {
                            Text("Daily Check-In")
                                .font(.phoenixTitle3)
                                .foregroundColor(.phoenixTextPrimary)
                            
                            Spacer()
                            
                            Text("\(currentStep + 1) of \(totalSteps)")
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
                                    .frame(width: geometry.size.width * (Double(currentStep + 1) / Double(totalSteps)), height: 8)
                                    .animation(.easeInOut(duration: 0.5), value: currentStep)
                            }
                        }
                        .frame(height: 8)
                    }
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.top, Spacing.md)
                
                // Content
                TabView(selection: $currentStep) {
                    // Step 1: Mood Level
                    MoodStepView(moodLevel: $moodLevel)
                        .tag(0)
                    
                    // Step 2: Urge Level
                    UrgeStepView(urgeLevel: $urgeLevel)
                        .tag(1)
                    
                    // Step 3: Trigger Context
                    TriggerStepView(triggerContext: $triggerContext)
                        .tag(2)
                    
                    // Step 4: Additional Notes
                    NotesStepView(note: $note)
                        .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: currentStep)
                
                // Navigation Buttons
                HStack(spacing: Spacing.md) {
                    if currentStep > 0 {
                        PhoenixButton(
                            title: "Back",
                            action: { previousStep() },
                            style: .secondary,
                            size: .medium
                        )
                        .frame(maxWidth: .infinity)
                    }
                    
                    PhoenixButton(
                        title: currentStep == totalSteps - 1 ? "Complete Check-In" : "Next",
                        action: { nextStep() },
                        isLoading: isSubmitting,
                        isDisabled: !canProceed()
                    )
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.bottom, Spacing.xl)
            }
            
            // Quick Actions Overlay for High Urge
            if urgeLevel > 5 && currentStep == 1 {
                QuickActionsOverlay()
                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)))
            }
            
            // Success Overlay
            if showingSuccess {
                CheckInSuccessView {
                    showingSuccess = false
                    resetCheckIn()
                }
                .transition(.asymmetric(insertion: .scale.combined(with: .opacity), removal: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: urgeLevel > 5)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showingSuccess)
    }
    
    private func canProceed() -> Bool {
        switch currentStep {
        case 0: return true // Mood always has a value
        case 1: return true // Urge always has a value
        case 2: return !triggerContext.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case 3: return true // Notes are optional
        default: return false
        }
    }
    
    private func nextStep() {
        if currentStep < totalSteps - 1 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentStep += 1
            }
            
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        } else {
            submitCheckIn()
        }
    }
    
    private func previousStep() {
        if currentStep > 0 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentStep -= 1
            }
        }
    }
    
    private func submitCheckIn() {
        isSubmitting = true
        
        // Save to Core Data first (for offline support)
        coreDataStack.saveCheckIn(
            moodLevel: Int(moodLevel),
            urgeLevel: Int(urgeLevel),
            triggerContext: triggerContext,
            note: note
        )
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isSubmitting = false
            showingSuccess = true
            
            // Success haptic
            let notificationFeedback = UINotificationFeedbackGenerator()
            notificationFeedback.notificationOccurred(.success)
        }
    }
    
    private func resetCheckIn() {
        currentStep = 0
        moodLevel = 5
        urgeLevel = 1
        triggerContext = ""
        note = ""
    }
}

// MARK: - Step Views

struct MoodStepView: View {
    @Binding var moodLevel: Double
    
    private let moodLabels = ["Very Low", "Low", "Neutral", "Good", "Great"]
    
    var body: some View {
        PhoenixCard {
            VStack(spacing: Spacing.xl) {
                VStack(spacing: Spacing.md) {
                    Text("How's your mood today?")
                        .font(.phoenixTitle2)
                        .foregroundColor(.phoenixTextPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text("Drag the slider to rate your mood")
                        .font(.phoenixBody)
                        .foregroundColor(.phoenixTextSecondary)
                        .multilineTextAlignment(.center)
                }
                
                VStack(spacing: Spacing.lg) {
                    // Mood Level Display
                    Text("\(Int(moodLevel))/10")
                        .font(.phoenixTitle1)
                        .foregroundColor(.phoenixPrimary)
                        .fontWeight(.bold)
                    
                    Text(moodLabels[min(Int(moodLevel - 1) / 2, 4)])
                        .font(.phoenixHeadline)
                        .foregroundColor(.phoenixTextSecondary)
                    
                    // Modern Custom Slider
                    ModernMoodSlider(
                        value: $moodLevel,
                        range: 1...10,
                        step: 1
                    )
                }
            }
        }
        .padding(.horizontal, Spacing.lg)
    }
}

struct UrgeStepView: View {
    @Binding var urgeLevel: Double
    
    private let urgeLabels = ["None", "Mild", "Moderate", "Strong", "Intense"]
    
    private var currentColor: Color {
        if urgeLevel <= 3 { return .phoenixSuccess }
        else if urgeLevel <= 6 { return .phoenixWarning }
        else { return .phoenixDanger }
    }
    
    var body: some View {
        PhoenixCard {
            VStack(spacing: Spacing.xl) {
                VStack(spacing: Spacing.md) {
                    Text("Any urges today?")
                        .font(.phoenixTitle2)
                        .foregroundColor(.phoenixTextPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text("Drag to rate the intensity of any urges")
                        .font(.phoenixBody)
                        .foregroundColor(.phoenixTextSecondary)
                        .multilineTextAlignment(.center)
                }
                
                VStack(spacing: Spacing.lg) {
                    Text(urgeLabels[min(Int(urgeLevel - 1) / 2, 4)])
                        .font(.phoenixHeadline)
                        .foregroundColor(currentColor)
                        .fontWeight(.semibold)
                    
                    // Modern Custom Slider with Progress Ring
                    ModernUrgeSlider(
                        value: $urgeLevel,
                        range: 1...10,
                        step: 1
                    )
                }
            }
        }
        .padding(.horizontal, Spacing.lg)
    }
}

struct TriggerStepView: View {
    @Binding var triggerContext: String
    @State private var selectedTriggers: Set<String> = []
    
    private let triggerOptions = [
        TriggerOption(id: "stress", title: "Work Stress", icon: "briefcase.fill", color: .phoenixDanger),
        TriggerOption(id: "social", title: "Social Anxiety", icon: "person.2.fill", color: .phoenixWarning),
        TriggerOption(id: "boredom", title: "Boredom", icon: "clock.fill", color: .phoenixTextSecondary),
        TriggerOption(id: "anxiety", title: "General Anxiety", icon: "heart.fill", color: .phoenixDanger),
        TriggerOption(id: "loneliness", title: "Loneliness", icon: "person.fill", color: .phoenixPrimaryDark),
        TriggerOption(id: "frustration", title: "Frustration", icon: "exclamationmark.triangle.fill", color: .phoenixWarning),
        TriggerOption(id: "sadness", title: "Sadness", icon: "cloud.rain.fill", color: .phoenixPrimaryDark),
        TriggerOption(id: "overwhelm", title: "Overwhelmed", icon: "tornado", color: .phoenixDanger),
        TriggerOption(id: "tired", title: "Exhaustion", icon: "bed.double.fill", color: .phoenixTextSecondary),
        TriggerOption(id: "conflict", title: "Conflict", icon: "bolt.fill", color: .phoenixDanger),
        TriggerOption(id: "pressure", title: "Pressure", icon: "gauge.high", color: .phoenixWarning),
        TriggerOption(id: "rejection", title: "Rejection", icon: "hand.raised.fill", color: .phoenixDanger)
    ]
    
    var body: some View {
        PhoenixCard {
            VStack(spacing: Spacing.xl) {
                VStack(spacing: Spacing.md) {
                    Text("What triggered these feelings?")
                        .font(.phoenixTitle2)
                        .foregroundColor(.phoenixTextPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text("Tap all that apply - no typing required!")
                        .font(.phoenixBody)
                        .foregroundColor(.phoenixTextSecondary)
                        .multilineTextAlignment(.center)
                }
                
                // Selected Triggers Summary
                if !selectedTriggers.isEmpty {
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Text("Selected:")
                            .font(.phoenixBodySecondary)
                            .foregroundColor(.phoenixTextSecondary)
                            .fontWeight(.semibold)
                        
                        Text(selectedTriggers.joined(separator: ", "))
                            .font(.phoenixBody)
                            .foregroundColor(.phoenixTextPrimary)
                            .padding(Spacing.md)
                            .background(
                                RoundedRectangle(cornerRadius: CornerRadius.md)
                                    .fill(Color.phoenixPrimary.opacity(0.1))
                            )
                    }
                }
                
                // Trigger Options Grid
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: Spacing.md) {
                    ForEach(triggerOptions, id: \.id) { trigger in
                        TriggerOptionButton(
                            trigger: trigger,
                            isSelected: selectedTriggers.contains(trigger.title),
                            action: { toggleTrigger(trigger.title) }
                        )
                    }
                }
            }
        }
        .padding(.horizontal, Spacing.lg)
        .onAppear {
            // Initialize from existing context
            if !triggerContext.isEmpty {
                selectedTriggers = Set(triggerContext.components(separatedBy: ", "))
            }
        }
        .onChange(of: selectedTriggers) { _, newValue in
            triggerContext = Array(newValue).joined(separator: ", ")
        }
    }
    
    private func toggleTrigger(_ trigger: String) {
        if selectedTriggers.contains(trigger) {
            selectedTriggers.remove(trigger)
        } else {
            selectedTriggers.insert(trigger)
        }
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
}

struct TriggerOption {
    let id: String
    let title: String
    let icon: String
    let color: Color
}

struct TriggerOptionButton: View {
    let trigger: TriggerOption
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.sm) {
                ZStack {
                    Circle()
                        .fill(isSelected ? trigger.color : Color.phoenixSurfaceLight)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: trigger.icon)
                        .font(.title3)
                        .foregroundColor(isSelected ? .white : trigger.color)
                }
                
                Text(trigger.title)
                    .font(.phoenixCaption)
                    .foregroundColor(isSelected ? trigger.color : .phoenixTextSecondary)
                    .fontWeight(isSelected ? .semibold : .medium)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding(Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.md)
                    .fill(isSelected ? trigger.color.opacity(0.1) : Color.phoenixCardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.md)
                            .stroke(isSelected ? trigger.color : Color.phoenixSurfaceLight, lineWidth: 2)
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .scaleEffect(isSelected ? 1.05 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isSelected)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
    }
}



struct NotesStepView: View {
    @Binding var note: String
    
    var body: some View {
        PhoenixCard {
            VStack(spacing: Spacing.xl) {
                VStack(spacing: Spacing.md) {
                    Text("Any additional thoughts?")
                        .font(.phoenixTitle2)
                        .foregroundColor(.phoenixTextPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text("Optional: Share any other observations or reflections")
                        .font(.phoenixBody)
                        .foregroundColor(.phoenixTextSecondary)
                        .multilineTextAlignment(.center)
                }
                
                // Notes Input
                VStack(alignment: .leading, spacing: Spacing.md) {
                    TextField("What else is on your mind? Any wins, challenges, or insights from today?", text: $note, axis: .vertical)
                        .font(.phoenixBody)
                        .padding(Spacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: CornerRadius.md)
                                .fill(Color.phoenixSurfaceLight)
                        )
                        .lineLimit(4...8)
                    
                    Text("This is completely optional but can help track your progress.")
                        .font(.phoenixCaption)
                        .foregroundColor(.phoenixTextTertiary)
                }
                
                // Encouragement
                VStack(spacing: Spacing.sm) {
                    Image(systemName: "heart.fill")
                        .font(.title)
                        .foregroundColor(.phoenixPrimary)
                    
                    Text("You're doing great by checking in!")
                        .font(.phoenixBody)
                        .foregroundColor(.phoenixTextPrimary)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding(.horizontal, Spacing.lg)
    }
}

// MARK: - Overlays

struct QuickActionsOverlay: View {
    var body: some View {
        VStack {
            Spacer()
            
            PhoenixCard(shadow: PhoenixShadow.floating) {
                VStack(spacing: Spacing.lg) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.phoenixWarning)
                        
                        Text("Need immediate help?")
                            .font(.phoenixHeadline)
                            .foregroundColor(.phoenixTextPrimary)
                            .fontWeight(.semibold)
                        
                        Spacer()
                    }
                    
                    VStack(spacing: Spacing.md) {
                        PhoenixButton(
                            title: "Open Urge Buster Tools",
                            action: { /* Navigate to urge buster */ },
                            style: .warning
                        )
                        
                        PhoenixButton(
                            title: "Emergency Contact",
                            action: { /* Call emergency contact */ },
                            style: .danger
                        )
                    }
                }
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.bottom, 120) // Account for navigation buttons
        }
    }
}

struct CheckInSuccessView: View {
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { onDismiss() }
            
            PhoenixCard {
                VStack(spacing: Spacing.xl) {
                    // Success Animation
                    ZStack {
                        Circle()
                            .fill(Color.phoenixSuccess.opacity(0.2))
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.phoenixSuccess)
                    }
                    
                    VStack(spacing: Spacing.md) {
                        Text("Check-In Complete!")
                            .font(.phoenixTitle2)
                            .foregroundColor(.phoenixTextPrimary)
                            .fontWeight(.bold)
                        
                        Text("Great job taking care of your mental health today. Keep up the amazing work!")
                            .font(.phoenixBody)
                            .foregroundColor(.phoenixTextSecondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    // XP Gained
                    HStack(spacing: Spacing.sm) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.phoenixWarning)
                        
                        Text("+50 XP")
                            .font(.phoenixHeadline)
                            .foregroundColor(.phoenixTextPrimary)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal, Spacing.lg)
                    .padding(.vertical, Spacing.sm)
                    .background(
                        RoundedRectangle(cornerRadius: CornerRadius.pill)
                            .fill(Color.phoenixWarning.opacity(0.1))
                    )
                    
                    PhoenixButton(
                        title: "Continue",
                        action: onDismiss
                    )
                }
            }
            .padding(.horizontal, Spacing.xl)
        }
    }
}

#Preview {
    CheckInView()
} 