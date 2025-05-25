import SwiftUI

struct QuizGameView: View {
    let domain: QuizDomain
    let onBack: () -> Void
    let onComplete: (QuizResult) -> Void
    
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: Int? = nil
    @State private var showingResult = false
    @State private var score = 0
    @State private var timeRemaining = 30
    @State private var isTimerActive = true
    
    private let questions: [QuizQuestion]
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(domain: QuizDomain, onBack: @escaping () -> Void, onComplete: @escaping (QuizResult) -> Void) {
        self.domain = domain
        self.onBack = onBack
        self.onComplete = onComplete
        self.questions = Quiz.generateQuiz(for: domain).questions
    }
    
    private var currentQuestion: QuizQuestion {
        questions[currentQuestionIndex]
    }
    
    private var isLastQuestion: Bool {
        currentQuestionIndex == questions.count - 1
    }
    
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
                    
                    Text(domain.title)
                        .font(.phoenixHeadline)
                        .foregroundColor(.phoenixTextPrimary)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    // Timer
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: "timer")
                            .font(.caption)
                            .foregroundColor(timeRemaining <= 10 ? .phoenixDanger : .phoenixTextSecondary)
                        
                        Text("\(timeRemaining)s")
                            .font(.phoenixBodySecondary)
                            .foregroundColor(timeRemaining <= 10 ? .phoenixDanger : .phoenixTextSecondary)
                            .fontWeight(.medium)
                    }
                }
                
                // Progress Bar
                ProgressView(value: Double(currentQuestionIndex + 1), total: Double(questions.count))
                    .progressViewStyle(LinearProgressViewStyle(tint: domain.color))
                    .scaleEffect(y: 2)
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.top, Spacing.md)
            
            // Question Content
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    VStack(spacing: Spacing.lg) {
                        // Question Number
                        Text("Question \(currentQuestionIndex + 1) of \(questions.count)")
                            .font(.phoenixCaption)
                            .foregroundColor(.phoenixTextSecondary)
                        
                        // Question Text
                        Text(currentQuestion.question)
                            .font(.phoenixTitle3)
                            .foregroundColor(.phoenixTextPrimary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Spacing.lg)
                    }
                    .padding(.top, Spacing.xl)
                    
                    // Answer Options
                    VStack(spacing: Spacing.md) {
                        ForEach(Array(currentQuestion.options.enumerated()), id: \.offset) { index, option in
                            OptionButton(
                                text: option,
                                isSelected: selectedAnswer == index,
                                isCorrect: showingResult && index == currentQuestion.correctAnswer,
                                isWrong: showingResult && selectedAnswer == index && index != currentQuestion.correctAnswer,
                                action: {
                                    if !showingResult {
                                        selectAnswer(index)
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal, Spacing.lg)
                    
                    // Explanation (shown after answer)
                    if showingResult, let explanation = currentQuestion.explanation {
                        PhoenixCard {
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("Explanation")
                                    .font(.phoenixHeadline)
                                    .foregroundColor(.phoenixTextPrimary)
                                    .fontWeight(.semibold)
                                
                                Text(explanation)
                                    .font(.phoenixBody)
                                    .foregroundColor(.phoenixTextSecondary)
                            }
                        }
                        .padding(.horizontal, Spacing.lg)
                    }
                    
                    // Next Button
                    if showingResult {
                        PhoenixButton(
                            title: isLastQuestion ? "Finish Quiz" : "Next Question",
                            action: nextQuestion
                        )
                        .padding(.horizontal, Spacing.lg)
                    }
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .onReceive(timer) { _ in
            if isTimerActive && timeRemaining > 0 {
                timeRemaining -= 1
            } else if timeRemaining == 0 && !showingResult {
                // Time's up - auto-select no answer
                selectAnswer(-1)
            }
        }
    }
    
    private func selectAnswer(_ index: Int) {
        selectedAnswer = index
        isTimerActive = false
        
        // Check if correct
        if index == currentQuestion.correctAnswer {
            score += 1
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            showingResult = true
        }
        
        // Haptic feedback
        let notificationFeedback = UINotificationFeedbackGenerator()
        if index == currentQuestion.correctAnswer {
            notificationFeedback.notificationOccurred(.success)
        } else {
            notificationFeedback.notificationOccurred(.error)
        }
    }
    
    private func nextQuestion() {
        if isLastQuestion {
            // Quiz complete
            let result = QuizResult(
                domain: domain,
                score: score,
                totalQuestions: questions.count,
                completedAt: Date()
            )
            onComplete(result)
        } else {
            // Next question
            withAnimation(.easeInOut(duration: 0.3)) {
                currentQuestionIndex += 1
                selectedAnswer = nil
                showingResult = false
                timeRemaining = 30
                isTimerActive = true
            }
        }
    }
}

struct OptionButton: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool
    let isWrong: Bool
    let action: () -> Void
    
    var backgroundColor: Color {
        if isCorrect {
            return .phoenixSuccess.opacity(0.2)
        } else if isWrong {
            return .phoenixDanger.opacity(0.2)
        } else if isSelected {
            return .phoenixPrimary.opacity(0.1)
        } else {
            return .phoenixCardBackground
        }
    }
    
    var borderColor: Color {
        if isCorrect {
            return .phoenixSuccess
        } else if isWrong {
            return .phoenixDanger
        } else if isSelected {
            return .phoenixPrimary
        } else {
            return .phoenixBorder
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.md) {
                Text(text)
                    .font(.phoenixBody)
                    .foregroundColor(.phoenixTextPrimary)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if isCorrect {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.phoenixSuccess)
                } else if isWrong {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.phoenixDanger)
                }
            }
            .padding(Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.lg)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.lg)
                            .stroke(borderColor, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    QuizGameView(
        domain: .techTrivia,
        onBack: {},
        onComplete: { _ in }
    )
} 