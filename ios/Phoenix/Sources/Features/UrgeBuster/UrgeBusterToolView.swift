import SwiftUI

struct UrgeBusterToolView: View {
    let tool: UrgeBusterTool
    let onComplete: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: tool.icon)
                        .font(.system(size: 60))
                        .foregroundStyle(tool.color)
                    
                    Text(tool.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(tool.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                
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
                
                Spacer()
                
                // Complete Button
                Button {
                    onComplete()
                } label: {
                    Text("I'm feeling better")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(tool.color)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .navigationTitle(tool.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        onComplete()
                    }
                }
            }
        }
    }
}

struct QuickPuzzleView: View {
    @State private var currentNumber = Int.random(in: 10...99)
    @State private var userAnswer = ""
    @State private var isCorrect: Bool?
    
    var correctAnswer: Int {
        currentNumber * 2
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Quick Math Challenge")
                .font(.headline)
            
            Text("What is \(currentNumber) × 2?")
                .font(.title)
                .fontWeight(.bold)
            
            TextField("Your answer", text: $userAnswer)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
            
            Button {
                checkAnswer()
            } label: {
                Text("Check Answer")
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .padding()
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .disabled(userAnswer.isEmpty)
            
            if let isCorrect = isCorrect {
                Text(isCorrect ? "Correct! 🎉" : "Try again!")
                    .font(.headline)
                    .foregroundStyle(isCorrect ? .green : .orange)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func checkAnswer() {
        isCorrect = Int(userAnswer) == correctAnswer
        if isCorrect == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                generateNewPuzzle()
            }
        }
    }
    
    private func generateNewPuzzle() {
        currentNumber = Int.random(in: 10...99)
        userAnswer = ""
        isCorrect = nil
    }
}

struct ColdWaterTimerView: View {
    @State private var timeRemaining = 30
    @State private var isRunning = false
    @State private var timer: Timer?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Cold Water Exercise")
                .font(.headline)
            
            Text("Hold cold water or ice cubes")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text("\(timeRemaining)")
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .foregroundStyle(.cyan)
            
            Text("seconds")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Button {
                if isRunning {
                    stopTimer()
                } else {
                    startTimer()
                }
            } label: {
                Text(isRunning ? "Stop" : "Start")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(width: 100)
                    .padding()
                    .background(.cyan)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func startTimer() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                stopTimer()
            }
        }
    }
    
    private func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
        timeRemaining = 30
    }
}

struct TwoFactorPromptView: View {
    @State private var currentStep = 0
    
    let prompts = [
        "Are you sure you want to do this?",
        "How will you feel in 10 minutes?",
        "What would your future self say?",
        "Is this aligned with your goals?"
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Two-Factor Check")
                .font(.headline)
            
            Text("Step \(currentStep + 1) of \(prompts.count)")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(prompts[currentStep])
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding()
            
            HStack(spacing: 20) {
                Button {
                    // User said no - good!
                    if currentStep < prompts.count - 1 {
                        currentStep += 1
                    }
                } label: {
                    Text("No")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 80)
                        .padding()
                        .background(.green)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                Button {
                    // User said yes - continue prompting
                    if currentStep < prompts.count - 1 {
                        currentStep += 1
                    }
                } label: {
                    Text("Yes")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 80)
                        .padding()
                        .background(.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            
            if currentStep == prompts.count - 1 {
                Text("Take a moment to really think about this decision.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct SafetyCheckView: View {
    let safetyReminders = [
        "You've come so far in your recovery journey.",
        "This feeling will pass. You are stronger than this urge.",
        "Remember why you started this journey.",
        "You have people who care about you and believe in you.",
        "Every moment you resist makes you stronger."
    ]
    
    @State private var currentReminder = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Safety Reminder")
                .font(.headline)
            
            Text(currentReminder)
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding()
                .background(.orange.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Button {
                generateNewReminder()
            } label: {
                Text("Another Reminder")
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .padding()
                    .background(.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onAppear {
            generateNewReminder()
        }
    }
    
    private func generateNewReminder() {
        currentReminder = safetyReminders.randomElement() ?? safetyReminders[0]
    }
}

struct MemoryFlashbackView: View {
    let memories = [
        "Remember the day you decided to change your life?",
        "Think about how proud you felt after your first week.",
        "Recall the support from people who believe in you.",
        "Remember how clear your mind felt during recovery.",
        "Think about the goals you set for yourself."
    ]
    
    @State private var currentMemory = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Memory Flashback")
                .font(.headline)
            
            Image(systemName: "brain.head.profile")
                .font(.system(size: 40))
                .foregroundStyle(.purple)
            
            Text(currentMemory)
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding()
                .background(.purple.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Button {
                generateNewMemory()
            } label: {
                Text("Another Memory")
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .padding()
                    .background(.purple)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onAppear {
            generateNewMemory()
        }
    }
    
    private func generateNewMemory() {
        currentMemory = memories.randomElement() ?? memories[0]
    }
}

#Preview {
    UrgeBusterToolView(tool: .quickPuzzle) {
        // Preview completion
    }
} 