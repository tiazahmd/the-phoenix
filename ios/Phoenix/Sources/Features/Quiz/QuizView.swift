import SwiftUI

struct QuizView: View {
    @State private var selectedDomain: InterestDomain = .techTrivia
    @State private var currentQuiz: Quiz?
    @State private var showingQuiz = false
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Daily Quiz")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Challenge yourself with personalized questions")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top)
                    
                    // Domain Selection
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Choose Your Interest")
                            .font(.headline)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(InterestDomain.allCases) { domain in
                                DomainCard(
                                    domain: domain,
                                    isSelected: selectedDomain == domain
                                ) {
                                    selectedDomain = domain
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 2)
                    
                    // Start Quiz Button
                    Button {
                        startQuiz()
                    } label: {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .tint(.white)
                            } else {
                                Image(systemName: "play.circle.fill")
                            }
                            Text(isLoading ? "Generating Quiz..." : "Start Quiz")
                        }
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.indigo)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(isLoading)
                    
                    // Recent Quiz History
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Recent Quizzes")
                            .font(.headline)
                        
                        ForEach(sampleQuizHistory) { history in
                            QuizHistoryRow(history: history)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 2)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Quiz")
            .sheet(isPresented: $showingQuiz) {
                if let quiz = currentQuiz {
                    QuizSessionView(quiz: quiz) {
                        showingQuiz = false
                        currentQuiz = nil
                    }
                }
            }
        }
    }
    
    private func startQuiz() {
        isLoading = true
        
        // TODO: Implement API call to POST /quizzes
        // Simulate API delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            currentQuiz = Quiz.sample(for: selectedDomain)
            isLoading = false
            showingQuiz = true
        }
    }
}

struct DomainCard: View {
    let domain: InterestDomain
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(domain.emoji)
                    .font(.title)
                
                Text(domain.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isSelected ? .indigo.opacity(0.2) : Color(.systemGray6))
            .foregroundStyle(isSelected ? .indigo : .primary)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(isSelected ? .indigo : .clear, lineWidth: 2)
            )
        }
    }
}

struct QuizHistoryRow: View {
    let history: QuizHistory
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(history.domain.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("\(history.correctAnswers)/\(history.totalQuestions) correct")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(history.date, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text("\(Int(history.accuracy * 100))%")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(history.accuracy > 0.7 ? .green : .orange)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Models

enum InterestDomain: String, CaseIterable, Identifiable {
    case rdr2 = "rdr2"
    case cyberpunk = "cyberpunk"
    case ghostOfTsushima = "ghost_of_tsushima"
    case footballManager = "football_manager"
    case techTrivia = "tech_trivia"
    case realMadrid = "real_madrid"
    case historicalEvents = "historical_events"
    case sciFi = "sci_fi"
    case sherlockHolmes = "sherlock_holmes"
    case guitarBasics = "guitar_basics"
    case harryPotter = "harry_potter"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .rdr2: return "Red Dead Redemption 2"
        case .cyberpunk: return "Cyberpunk 2077"
        case .ghostOfTsushima: return "Ghost of Tsushima"
        case .footballManager: return "Football Manager"
        case .techTrivia: return "Tech Trivia"
        case .realMadrid: return "Real Madrid"
        case .historicalEvents: return "Historical Events"
        case .sciFi: return "Sci-Fi"
        case .sherlockHolmes: return "Sherlock Holmes"
        case .guitarBasics: return "Guitar Basics"
        case .harryPotter: return "Harry Potter"
        }
    }
    
    var emoji: String {
        switch self {
        case .rdr2: return "🤠"
        case .cyberpunk: return "🤖"
        case .ghostOfTsushima: return "⚔️"
        case .footballManager: return "⚽"
        case .techTrivia: return "💻"
        case .realMadrid: return "👑"
        case .historicalEvents: return "📚"
        case .sciFi: return "🚀"
        case .sherlockHolmes: return "🔍"
        case .guitarBasics: return "🎸"
        case .harryPotter: return "⚡"
        }
    }
}

struct Quiz: Identifiable {
    let id = UUID()
    let domain: InterestDomain
    let questions: [QuizQuestion]
    
    static func sample(for domain: InterestDomain) -> Quiz {
        Quiz(domain: domain, questions: QuizQuestion.sampleQuestions(for: domain))
    }
}

struct QuizQuestion: Identifiable {
    let id = UUID()
    let question: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String
    let tip: String
    
    static func sampleQuestions(for domain: InterestDomain) -> [QuizQuestion] {
        switch domain {
        case .techTrivia:
            return [
                QuizQuestion(
                    question: "What does API stand for?",
                    options: ["Application Programming Interface", "Advanced Programming Integration", "Automated Process Integration", "Application Process Interface"],
                    correctAnswer: 0,
                    explanation: "API stands for Application Programming Interface, which allows different software applications to communicate with each other.",
                    tip: "Just like managing urges, APIs help different systems work together smoothly through clear communication."
                )
            ]
        case .harryPotter:
            return [
                QuizQuestion(
                    question: "What house was Harry Potter sorted into?",
                    options: ["Slytherin", "Hufflepuff", "Ravenclaw", "Gryffindor"],
                    correctAnswer: 3,
                    explanation: "Harry Potter was sorted into Gryffindor house, known for courage and bravery.",
                    tip: "Like Harry facing his fears, you can face your urges with courage and determination."
                )
            ]
        default:
            return [
                QuizQuestion(
                    question: "Sample question for \(domain.title)",
                    options: ["Option A", "Option B", "Option C", "Option D"],
                    correctAnswer: 0,
                    explanation: "This is a sample explanation.",
                    tip: "This is a sample tip connecting to recovery."
                )
            ]
        }
    }
}

struct QuizHistory: Identifiable {
    let id = UUID()
    let domain: InterestDomain
    let date: Date
    let totalQuestions: Int
    let correctAnswers: Int
    
    var accuracy: Double {
        Double(correctAnswers) / Double(totalQuestions)
    }
}

// Sample data
let sampleQuizHistory = [
    QuizHistory(domain: .techTrivia, date: Date(), totalQuestions: 5, correctAnswers: 4),
    QuizHistory(domain: .harryPotter, date: Date().addingTimeInterval(-86400), totalQuestions: 3, correctAnswers: 2),
    QuizHistory(domain: .realMadrid, date: Date().addingTimeInterval(-172800), totalQuestions: 4, correctAnswers: 4)
]

#Preview {
    QuizView()
} 