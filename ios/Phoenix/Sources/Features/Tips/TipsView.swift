import SwiftUI

struct TipsView: View {
    @State private var selectedCategory: TipCategory = .all
    @State private var searchText = ""
    @State private var tips: [Tip] = []
    @State private var isLoading = false
    @State private var animateCards = false
    
    private let categories = TipCategory.allCases
    
    var filteredTips: [Tip] {
        var filtered = tips
        
        if selectedCategory != .all {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { tip in
                tip.title.localizedCaseInsensitiveContains(searchText) ||
                tip.content.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered
    }
    
    var body: some View {
        ZStack {
            Color.phoenixBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: Spacing.lg) {
                    HStack {
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            Text("Recovery Tips")
                                .font(.phoenixTitle2)
                                .foregroundColor(.phoenixTextPrimary)
                            
                            Text("Wisdom for your journey")
                                .font(.phoenixBody)
                                .foregroundColor(.phoenixTextSecondary)
                        }
                        
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.phoenixPrimaryLight, .phoenixPrimary],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: "lightbulb.fill")
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                    }
                    
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.phoenixTextTertiary)
                        
                        TextField("Search tips...", text: $searchText)
                            .font(.phoenixBody)
                    }
                    .padding(Spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: CornerRadius.md)
                            .fill(Color.phoenixSurfaceLight)
                    )
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.top, Spacing.md)
                
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.md) {
                        ForEach(categories, id: \.self) { category in
                            CategoryFilterButton(
                                category: category,
                                isSelected: selectedCategory == category
                            ) {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedCategory = category
                                }
                            }
                        }
                    }
                    .padding(.horizontal, Spacing.lg)
                }
                .padding(.vertical, Spacing.md)
                
                // Tips Content
                if isLoading {
                    LoadingView()
                } else if filteredTips.isEmpty {
                    EmptyTipsView(searchText: searchText, selectedCategory: selectedCategory)
                } else {
                    TipsListView(tips: filteredTips, animateCards: animateCards)
                }
                
                Spacer(minLength: 100)
            }
        }
        .onAppear {
            loadTips()
            withAnimation(.easeInOut(duration: 0.8).delay(0.3)) {
                animateCards = true
            }
        }
    }
    
    private func loadTips() {
        isLoading = true
        
        // Simulate API call - replace with actual API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            tips = Tip.sampleTips
            isLoading = false
        }
    }
}

struct CategoryFilterButton: View {
    let category: TipCategory
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.sm) {
                Image(systemName: category.icon)
                    .font(.caption)
                    .foregroundColor(isSelected ? .white : category.color)
                
                Text(category.title)
                    .font(.phoenixBodySecondary)
                    .foregroundColor(isSelected ? .white : category.color)
                    .fontWeight(isSelected ? .semibold : .medium)
            }
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.pill)
                    .fill(isSelected ? category.color : category.color.opacity(0.1))
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isSelected)
    }
}

struct LoadingView: View {
    var body: some View {
        VStack(spacing: Spacing.lg) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.phoenixPrimary)
            
            Text("Loading tips...")
                .font(.phoenixBody)
                .foregroundColor(.phoenixTextSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct EmptyTipsView: View {
    let searchText: String
    let selectedCategory: TipCategory
    
    var body: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.phoenixTextTertiary)
            
            VStack(spacing: Spacing.sm) {
                Text("No tips found")
                    .font(.phoenixHeadline)
                    .foregroundColor(.phoenixTextPrimary)
                
                if !searchText.isEmpty {
                    Text("Try adjusting your search or browse different categories")
                        .font(.phoenixBody)
                        .foregroundColor(.phoenixTextSecondary)
                        .multilineTextAlignment(.center)
                } else {
                    Text("No tips available in this category yet")
                        .font(.phoenixBody)
                        .foregroundColor(.phoenixTextSecondary)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding(.horizontal, Spacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct TipsListView: View {
    let tips: [Tip]
    let animateCards: Bool
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: Spacing.lg) {
                ForEach(Array(tips.enumerated()), id: \.element.id) { index, tip in
                    TipCard(tip: tip)
                        .opacity(animateCards ? 1.0 : 0.0)
                        .offset(y: animateCards ? 0 : 50)
                        .animation(
                            .spring(response: 0.6, dampingFraction: 0.8)
                            .delay(Double(index) * 0.1),
                            value: animateCards
                        )
                }
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.vertical, Spacing.md)
        }
    }
}

struct TipCard: View {
    let tip: Tip
    @State private var isExpanded = false
    @State private var isBookmarked = false
    @State private var isPressed = false
    
    var body: some View {
        PhoenixCard {
            VStack(spacing: Spacing.md) {
                // Header
                HStack(spacing: Spacing.md) {
                    ZStack {
                        Circle()
                            .fill(tip.category.color.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: tip.category.icon)
                            .font(.title3)
                            .foregroundColor(tip.category.color)
                    }
                    
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text(tip.title)
                            .font(.phoenixHeadline)
                            .foregroundColor(.phoenixTextPrimary)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                        
                        Text(tip.category.title)
                            .font(.phoenixCaption)
                            .foregroundColor(tip.category.color)
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        isBookmarked.toggle()
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                    }) {
                        Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                            .font(.title3)
                            .foregroundColor(isBookmarked ? .phoenixWarning : .phoenixTextTertiary)
                    }
                }
                
                // Content
                VStack(alignment: .leading, spacing: Spacing.md) {
                    Text(tip.content)
                        .font(.phoenixBody)
                        .foregroundColor(.phoenixTextPrimary)
                        .lineLimit(isExpanded ? nil : 3)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if tip.content.count > 150 {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isExpanded.toggle()
                            }
                        }) {
                            Text(isExpanded ? "Show less" : "Read more")
                                .font(.phoenixBodySecondary)
                                .foregroundColor(.phoenixPrimary)
                                .fontWeight(.medium)
                        }
                    }
                    
                    // Action buttons (if tip is actionable)
                    if tip.isActionable {
                        HStack(spacing: Spacing.md) {
                            PhoenixButton(
                                title: "Try This",
                                action: {
                                    // TODO: Implement tip action
                                    let notificationFeedback = UINotificationFeedbackGenerator()
                                    notificationFeedback.notificationOccurred(.success)
                                },
                                style: .primary,
                                size: .small
                            )
                            
                            PhoenixButton(
                                title: "Share",
                                action: {
                                    // TODO: Implement sharing
                                },
                                style: .secondary,
                                size: .small
                            )
                        }
                    }
                }
                
                // Footer with engagement
                HStack {
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: "heart.fill")
                            .font(.caption)
                            .foregroundColor(.phoenixDanger)
                        Text("\(tip.likes)")
                            .font(.phoenixCaption)
                            .foregroundColor(.phoenixTextSecondary)
                    }
                    
                    Spacer()
                    
                    Text(tip.createdAt, style: .relative)
                        .font(.phoenixCaption)
                        .foregroundColor(.phoenixTextTertiary)
                }
            }
        }
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isExpanded)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isBookmarked)
    }
}

// MARK: - Supporting Types

enum TipCategory: String, CaseIterable {
    case all = "all"
    case mindfulness = "mindfulness"
    case coping = "coping"
    case motivation = "motivation"
    case health = "health"
    case relationships = "relationships"
    case emergency = "emergency"
    
    var title: String {
        switch self {
        case .all: return "All"
        case .mindfulness: return "Mindfulness"
        case .coping: return "Coping"
        case .motivation: return "Motivation"
        case .health: return "Health"
        case .relationships: return "Relationships"
        case .emergency: return "Emergency"
        }
    }
    
    var icon: String {
        switch self {
        case .all: return "square.grid.2x2"
        case .mindfulness: return "brain.head.profile"
        case .coping: return "shield.lefthalf.filled"
        case .motivation: return "star.fill"
        case .health: return "heart.fill"
        case .relationships: return "person.2.fill"
        case .emergency: return "exclamationmark.triangle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .all: return .phoenixTextSecondary
        case .mindfulness: return .phoenixPrimary
        case .coping: return .phoenixSuccess
        case .motivation: return .phoenixWarning
        case .health: return .phoenixDanger
        case .relationships: return .phoenixPrimaryLight
        case .emergency: return .phoenixDanger
        }
    }
}

struct Tip: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let content: String
    let category: TipCategory
    let isActionable: Bool
    let likes: Int
    let createdAt: Date
    
    static let sampleTips: [Tip] = [
        Tip(
            title: "The 5-4-3-2-1 Grounding Technique",
            content: "When feeling overwhelmed, try this: Name 5 things you can see, 4 things you can touch, " +
                    "3 things you can hear, 2 things you can smell, and 1 thing you can taste. " +
                    "This helps bring you back to the present moment and reduces anxiety.",
            category: .mindfulness,
            isActionable: true,
            likes: 127,
            createdAt: Date().addingTimeInterval(-3_600)
        ),
        Tip(
            title: "Create a Recovery Playlist",
            content: "Music can be incredibly powerful for mood regulation. Create a playlist of songs that " +
                    "motivate you, calm you down, or remind you of your goals. Having this ready can be a " +
                    "quick way to shift your emotional state when needed.",
            category: .coping,
            isActionable: true,
            likes: 89,
            createdAt: Date().addingTimeInterval(-7_200)
        ),
        Tip(
            title: "The Power of Small Wins",
            content: "Recovery isn't just about avoiding setbacks—it's about celebrating progress. " +
                    "Keep a list of small daily victories, like choosing a healthy meal, calling a friend, " +
                    "or completing a task. These add up to create momentum and confidence.",
            category: .motivation,
            isActionable: true,
            likes: 156,
            createdAt: Date().addingTimeInterval(-10_800)
        ),
        Tip(
            title: "Hydration and Recovery",
            content: "Staying properly hydrated supports both physical and mental health. " +
                    "Dehydration can worsen anxiety, depression, and cravings. Aim for 8 glasses of water daily, " +
                    "and consider adding electrolytes if you're active.",
            category: .health,
            isActionable: true,
            likes: 73,
            createdAt: Date().addingTimeInterval(-14_400)
        ),
        Tip(
            title: "Setting Boundaries with Triggers",
            content: "It's okay to limit contact with people, places, or situations that threaten your recovery. " +
                    "This isn't being antisocial—it's being protective of your progress. " +
                    "Communicate your needs clearly and don't feel guilty about prioritizing your health.",
            category: .relationships,
            isActionable: false,
            likes: 201,
            createdAt: Date().addingTimeInterval(-18_000)
        ),
        Tip(
            title: "Emergency Contact Protocol",
            content: "Have a clear plan for crisis moments: 1) Remove yourself from immediate triggers, " +
                    "2) Call your support person or therapist, 3) Use grounding techniques, " +
                    "4) If in immediate danger, call emergency services. Practice this plan when you're feeling stable.",
            category: .emergency,
            isActionable: true,
            likes: 312,
            createdAt: Date().addingTimeInterval(-21_600)
        ),
        Tip(
            title: "Morning Intention Setting",
            content: "Start each day by setting a simple intention. It could be 'I will be kind to myself today' " +
                    "or 'I will take things one moment at a time.' This creates a positive framework for " +
                    "decision-making throughout the day.",
            category: .mindfulness,
            isActionable: true,
            likes: 94,
            createdAt: Date().addingTimeInterval(-25_200)
        ),
        Tip(
            title: "The HALT Check",
            content: "When feeling triggered, ask yourself: Am I Hungry, Angry, Lonely, or Tired? " +
                    "Often, addressing these basic needs can significantly reduce urges and improve your emotional state. " +
                    "Keep healthy snacks, have a support contact ready, and prioritize sleep.",
            category: .coping,
            isActionable: true,
            likes: 178,
            createdAt: Date().addingTimeInterval(-28_800)
        )
    ]
}

#Preview {
    TipsView()
} 