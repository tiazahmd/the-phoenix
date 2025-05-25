import SwiftUI

struct QuizView: View {
    @State private var selectedDomain: InterestDomain?
    @State private var currentQuiz: Quiz?
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: String?
    @State private var showingResult = false
    @State private var isCorrect = false
    @State private var score = 0
    @State private var animateProgress = false
    @State private var showingDomainSelection = true
    
    private let domains = InterestDomain.allCases
    
    var body: some View {
        ZStack {
            Color.phoenixBackground.ignoresSafeArea()
            
            if showingDomainSelection {
                DomainSelectionView(
                    domains: domains,
                    onDomainSelected: { domain in
                        selectedDomain = domain
                        startQuiz(for: domain)
                    }
                )
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            } else if let quiz = currentQuiz {
                QuizGameView(
                    quiz: quiz,
                    currentQuestionIndex: $currentQuestionIndex,
                    selectedAnswer: $selectedAnswer,
                    showingResult: $showingResult,
                    isCorrect: $isCorrect,
                    score: $score,
                    animateProgress: $animateProgress,
                    onQuizComplete: {
                        // Reset for next quiz
                        showingDomainSelection = true
                        currentQuiz = nil
                        currentQuestionIndex = 0
                        score = 0
                    },
                    onBackToDomains: {
                        showingDomainSelection = true
                        currentQuiz = nil
                        currentQuestionIndex = 0
                        score = 0
                    }
                )
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showingDomainSelection)
    }
    
    private func startQuiz(for domain: InterestDomain) {
        currentQuiz = Quiz.generateQuiz(for: domain)
        showingDomainSelection = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 1.0)) {
                animateProgress = true
            }
        }
    }
}

#Preview {
    QuizView()
        .environmentObject(AuthenticationManager())
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
    
    var color: Color {
        switch self {
        case .rdr2: return .rdr2
        case .cyberpunk: return .cyberpunk
        case .ghostOfTsushima: return .ghostOfTsushima
        case .footballManager: return .footballManager
        case .techTrivia: return .techTrivia
        case .realMadrid: return .realMadrid
        case .historicalEvents: return .historicalEvents
        case .sciFi: return .sciFi
        case .sherlockHolmes: return .sherlockHolmes
        case .guitarBasics: return .guitarBasics
        case .harryPotter: return .harryPotter
        }
    }
    
    var icon: String {
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
    
    var displayName: String {
        title
    }
    
    var description: String {
        emoji
    }
}

struct Quiz: Identifiable {
    let id = UUID()
    let domain: InterestDomain
    let questions: [QuizQuestion]
    
    static func generateQuiz(for domain: InterestDomain) -> Quiz {
        Quiz(domain: domain, questions: QuizQuestion.sampleQuestions(for: domain))
    }
}

struct QuizQuestion: Identifiable {
    let id = UUID()
    let question: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String?
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

// MARK: - Supporting Views

struct DomainSelectionView: View {
    let domains: [InterestDomain]
    let onDomainSelected: (InterestDomain) -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xl) {
                VStack(spacing: Spacing.lg) {
                    Text("🧠")
                        .font(.system(size: 80))
                    
                    VStack(spacing: Spacing.sm) {
                        Text("Choose Your Challenge")
                            .font(.phoenixTitle2)
                            .foregroundColor(.phoenixTextPrimary)
                        
                        Text("Select a topic to test your knowledge")
                            .font(.phoenixBody)
                            .foregroundColor(.phoenixTextSecondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.top, Spacing.lg)
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: Spacing.lg) {
                    ForEach(domains) { domain in
                        DomainCard(domain: domain) {
                            onDomainSelected(domain)
                        }
                    }
                }
                .padding(.horizontal, Spacing.lg)
                
                Spacer(minLength: 100)
            }
            .padding(.vertical, Spacing.md)
        }
        .background(Color.phoenixBackground)
    }
}

struct DomainCard: View {
    let domain: InterestDomain
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.md) {
                Text(domain.emoji)
                    .font(.system(size: 50))
                
                VStack(spacing: Spacing.xs) {
                    Text(domain.title)
                        .font(.phoenixHeadline)
                        .foregroundColor(.phoenixTextPrimary)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
            .padding(Spacing.lg)
            .frame(height: 140)
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.lg)
                    .fill(Color.phoenixCardBackground)
                    .shadow(color: domain.color.opacity(0.2), radius: 8, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.lg)
                    .stroke(domain.color.opacity(0.3), lineWidth: 2)
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

struct QuizGameView: View {
    let quiz: Quiz
    @Binding var currentQuestionIndex: Int
    @Binding var selectedAnswer: String?
    @Binding var showingResult: Bool
    @Binding var isCorrect: Bool
    @Binding var score: Int
    @Binding var animateProgress: Bool
    let onQuizComplete: () -> Void
    let onBackToDomains: () -> Void
    
    var body: some View {
        VStack(spacing: Spacing.xl) {
            // Header
            HStack {
                Button(action: onBackToDomains) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.phoenixPrimary)
                }
                
                Spacer()
                
                Text(quiz.domain.title)
                    .font(.phoenixHeadline)
                    .foregroundColor(.phoenixTextPrimary)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(score)/\(quiz.questions.count)")
                    .font(.phoenixBodySecondary)
                    .foregroundColor(.phoenixTextSecondary)
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.top, Spacing.md)
            
            // Quiz Content
            VStack(spacing: Spacing.xl) {
                Text("Quiz Game Placeholder")
                    .font(.phoenixTitle2)
                    .foregroundColor(.phoenixTextPrimary)
                    .padding()
                
                Text("Question \(currentQuestionIndex + 1) of \(quiz.questions.count)")
                    .font(.phoenixBody)
                    .foregroundColor(.phoenixTextSecondary)
                
                PhoenixButton(
                    title: "Complete Quiz",
                    action: onQuizComplete,
                    style: .primary
                )
                .padding(.horizontal, Spacing.lg)
            }
            
            Spacer()
        }
        .background(Color.phoenixBackground)
    }
}