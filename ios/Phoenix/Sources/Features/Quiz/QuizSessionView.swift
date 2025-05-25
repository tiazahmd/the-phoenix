import SwiftUI

struct QuizSessionView: View {
    let quiz: Quiz
    let onComplete: () -> Void
    
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: Int?
    @State private var showingResult = false
    @State private var showingTip = false
    @State private var correctAnswers = 0
    @State private var userWantsToContinue = true
    
    private var currentQuestion: QuizQuestion {
        quiz.questions[currentQuestionIndex]
    }
    
    private var isLastQuestion: Bool {
        currentQuestionIndex == quiz.questions.count - 1
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Progress
                VStack(spacing: 8) {
                    HStack {
                        Text("Question \(currentQuestionIndex + 1)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Text(quiz.domain.title)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    ProgressView(value: Double(currentQuestionIndex + 1), total: Double(quiz.questions.count))
                        .tint(.indigo)
                }
                .padding()
                
                // Question
                VStack(alignment: .leading, spacing: 16) {
                    Text(currentQuestion.question)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                    
                    VStack(spacing: 12) {
                        ForEach(Array(currentQuestion.options.enumerated()), id: \.offset) { index, option in
                            OptionButton(
                                text: option,
                                isSelected: selectedAnswer == index,
                                isCorrect: showingResult ? index == currentQuestion.correctAnswer : nil,
                                isWrong: showingResult && selectedAnswer == index && index != currentQuestion.correctAnswer
                            ) {
                                if !showingResult {
                                    selectedAnswer = index
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 2)
                
                // Result Section
                if showingResult {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: selectedAnswer == currentQuestion.correctAnswer ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundStyle(selectedAnswer == currentQuestion.correctAnswer ? .green : .red)
                            
                            Text(selectedAnswer == currentQuestion.correctAnswer ? "Correct!" : "Incorrect")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        
                        Text(currentQuestion.explanation)
                            .font(.body)
                            .foregroundStyle(.secondary)
                        
                        Button {
                            showingTip = true
                        } label: {
                            HStack {
                                Image(systemName: "lightbulb.fill")
                                Text("View Recovery Tip")
                            }
                            .font(.subheadline)
                            .foregroundStyle(.indigo)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 2)
                }
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 12) {
                    if !showingResult {
                        Button {
                            submitAnswer()
                        } label: {
                            Text("Submit Answer")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(selectedAnswer != nil ? .indigo : .gray)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .disabled(selectedAnswer == nil)
                    } else {
                        if isLastQuestion {
                            VStack(spacing: 12) {
                                Button {
                                    generateNewQuestion()
                                } label: {
                                    Text("Continue Quiz")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(.indigo)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                                
                                Button {
                                    finishQuiz()
                                } label: {
                                    Text("Finish Quiz")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        } else {
                            Button {
                                nextQuestion()
                            } label: {
                                Text("Next Question")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(.indigo)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Quiz")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        onComplete()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Text("\(correctAnswers)/\(currentQuestionIndex + (showingResult ? 1 : 0))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .sheet(isPresented: $showingTip) {
                TipView(tip: currentQuestion.tip)
            }
        }
    }
    
    private func submitAnswer() {
        showingResult = true
        if selectedAnswer == currentQuestion.correctAnswer {
            correctAnswers += 1
        }
    }
    
    private func nextQuestion() {
        currentQuestionIndex += 1
        selectedAnswer = nil
        showingResult = false
    }
    
    private func generateNewQuestion() {
        // TODO: Implement API call to generate new question
        // For now, just finish the quiz
        finishQuiz()
    }
    
    private func finishQuiz() {
        // TODO: Submit quiz results to API
        onComplete()
    }
}

struct OptionButton: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool?
    let isWrong: Bool
    let action: () -> Void
    
    var backgroundColor: Color {
        if let isCorrect = isCorrect {
            if isCorrect {
                return .green.opacity(0.2)
            } else if isWrong {
                return .red.opacity(0.2)
            }
        }
        
        return isSelected ? .indigo.opacity(0.2) : Color(.systemGray6)
    }
    
    var borderColor: Color {
        if let isCorrect = isCorrect {
            if isCorrect {
                return .green
            } else if isWrong {
                return .red
            }
        }
        
        return isSelected ? .indigo : .clear
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if let isCorrect = isCorrect {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : (isWrong ? "xmark.circle.fill" : ""))
                        .foregroundStyle(isCorrect ? .green : .red)
                }
            }
            .padding()
            .background(backgroundColor)
            .foregroundStyle(.primary)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(borderColor, lineWidth: 2)
            )
        }
        .disabled(isCorrect != nil)
    }
}

struct TipView: View {
    let tip: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.yellow)
                
                Text("Recovery Tip")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(tip)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Text("Got it!")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.indigo)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Tip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    QuizSessionView(quiz: Quiz.sample(for: .techTrivia)) {
        // Preview completion
    }
} 