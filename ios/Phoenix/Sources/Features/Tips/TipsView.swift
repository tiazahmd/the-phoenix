import SwiftUI

struct TipsView: View {
    @State private var tips: [Tip] = sampleTips
    @State private var isLoading = false
    @State private var selectedCategory: TipCategory = .all
    
    var filteredTips: [Tip] {
        if selectedCategory == .all {
            return tips
        }
        return tips.filter { $0.category == selectedCategory }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(TipCategory.allCases) { category in
                            CategoryFilterButton(
                                category: category,
                                isSelected: selectedCategory == category
                            ) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                .background(Color(.systemBackground))
                
                // Tips List
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredTips) { tip in
                            TipCard(tip: tip)
                                .onAppear {
                                    if tip.id == filteredTips.last?.id {
                                        loadMoreTips()
                                    }
                                }
                        }
                        
                        if isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                    .padding()
                }
                .background(Color(.systemGroupedBackground))
            }
            .navigationTitle("Tips")
            .refreshable {
                await refreshTips()
            }
        }
    }
    
    private func loadMoreTips() {
        guard !isLoading else { return }
        
        isLoading = true
        
        // TODO: Implement API call to GET /tips?after_id=...
        // Simulate API delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let newTips = Tip.generateMoreTips()
            tips.append(contentsOf: newTips)
            isLoading = false
        }
    }
    
    private func refreshTips() async {
        // TODO: Implement API call to refresh tips
        // Simulate API delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        tips = sampleTips
    }
}

struct CategoryFilterButton: View {
    let category: TipCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(category.title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? .indigo : .clear)
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .strokeBorder(isSelected ? .clear : .secondary.opacity(0.3))
                )
        }
    }
}

struct TipCard: View {
    let tip: Tip
    @State private var isBookmarked = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(tip.category.title)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(tip.category.color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(tip.category.color.opacity(0.2))
                        .clipShape(Capsule())
                    
                    Text(tip.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                Button {
                    isBookmarked.toggle()
                } label: {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                        .foregroundStyle(.indigo)
                }
            }
            
            // Content
            Text(tip.content)
                .font(.body)
                .lineLimit(nil)
            
            // Action Steps (if any)
            if !tip.actionSteps.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Try this:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.indigo)
                    
                    ForEach(Array(tip.actionSteps.enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .top, spacing: 8) {
                            Text("\(index + 1).")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.indigo)
                            
                            Text(step)
                                .font(.subheadline)
                        }
                    }
                }
                .padding()
                .background(.indigo.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            // Footer
            HStack {
                Text(tip.source)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text(tip.readTime)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}

// MARK: - Models

enum TipCategory: String, CaseIterable, Identifiable {
    case all = "all"
    case urgeManagement = "urge_management"
    case mindfulness = "mindfulness"
    case habits = "habits"
    case motivation = "motivation"
    case science = "science"
    case community = "community"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .all: return "All"
        case .urgeManagement: return "Urge Management"
        case .mindfulness: return "Mindfulness"
        case .habits: return "Habits"
        case .motivation: return "Motivation"
        case .science: return "Science"
        case .community: return "Community"
        }
    }
    
    var color: Color {
        switch self {
        case .all: return .gray
        case .urgeManagement: return .red
        case .mindfulness: return .green
        case .habits: return .blue
        case .motivation: return .orange
        case .science: return .purple
        case .community: return .pink
        }
    }
}

struct Tip: Identifiable {
    let id = UUID()
    let title: String
    let content: String
    let category: TipCategory
    let actionSteps: [String]
    let source: String
    let readTime: String
    
    static func generateMoreTips() -> [Tip] {
        return [
            Tip(
                title: "The 5-4-3-2-1 Grounding Technique",
                content: "When you feel overwhelmed by urges, use this sensory grounding technique to bring yourself back to the present moment.",
                category: .urgeManagement,
                actionSteps: [
                    "Name 5 things you can see",
                    "Name 4 things you can touch",
                    "Name 3 things you can hear",
                    "Name 2 things you can smell",
                    "Name 1 thing you can taste"
                ],
                source: "Mindfulness Research",
                readTime: "2 min read"
            ),
            Tip(
                title: "Understanding Your Trigger Patterns",
                content: "Recovery isn't just about willpower—it's about understanding the science behind your habits and triggers.",
                category: .science,
                actionSteps: [
                    "Keep a trigger journal for one week",
                    "Note the time, place, and emotions",
                    "Look for patterns in your data",
                    "Plan alternative responses"
                ],
                source: "Behavioral Psychology",
                readTime: "3 min read"
            )
        ]
    }
}

// Sample data
let sampleTips = [
    Tip(
        title: "The Power of the Pause",
        content: "When you feel an urge, try pausing for just 10 seconds. This brief moment can be enough to break the automatic response and give you space to choose differently.",
        category: .urgeManagement,
        actionSteps: [
            "Feel the urge without acting",
            "Take 3 deep breaths",
            "Ask yourself: 'What do I really need right now?'",
            "Choose a healthy alternative"
        ],
        source: "Cognitive Behavioral Therapy",
        readTime: "2 min read"
    ),
    Tip(
        title: "Building Your Recovery Toolkit",
        content: "Having a variety of coping strategies ready makes you more resilient. Think of it like having different tools for different situations.",
        category: .habits,
        actionSteps: [
            "List 5 activities that bring you joy",
            "Identify 3 people you can call for support",
            "Practice one mindfulness technique daily",
            "Create a calming environment at home"
        ],
        source: "Recovery Specialists",
        readTime: "3 min read"
    ),
    Tip(
        title: "The Neuroscience of Habit Change",
        content: "Your brain is constantly rewiring itself. Every time you choose recovery over relapse, you're strengthening new neural pathways and weakening old ones.",
        category: .science,
        actionSteps: [],
        source: "Neuroscience Research",
        readTime: "4 min read"
    ),
    Tip(
        title: "Morning Mindfulness Routine",
        content: "Starting your day with intention can set a positive tone and increase your resilience to triggers throughout the day.",
        category: .mindfulness,
        actionSteps: [
            "Wake up 10 minutes earlier",
            "Practice 5 minutes of deep breathing",
            "Set one positive intention for the day",
            "Express gratitude for three things"
        ],
        source: "Mindfulness Practice",
        readTime: "2 min read"
    )
]

#Preview {
    TipsView()
} 