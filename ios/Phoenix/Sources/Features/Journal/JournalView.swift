import SwiftUI

struct JournalView: View {
    @State private var searchText = ""
    @State private var showingNewEntry = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Stats
                    StatsView()
                        .padding(.horizontal)
                    
                    // Entries
                    LazyVStack(spacing: 16) {
                        ForEach(sampleEntries) { entry in
                            JournalEntryCard(entry: entry)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Journal")
            .searchable(text: $searchText, prompt: "Search entries...")
            .background(Color(.systemGroupedBackground))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingNewEntry = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundStyle(.indigo)
                    }
                }
            }
            .sheet(isPresented: $showingNewEntry) {
                NewJournalEntryView()
            }
        }
    }
}

struct StatsView: View {
    var body: some View {
        HStack {
            StatCard(title: "Entries", value: "28", icon: "book.fill")
            StatCard(title: "Streak", value: "7", icon: "flame.fill")
            StatCard(title: "Minutes", value: "126", icon: "clock.fill")
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.indigo)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}

struct JournalEntryCard: View {
    let entry: JournalEntry
    
    var body: some View {
        NavigationLink(destination: JournalEntryDetailView(entry: entry)) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(entry.date, style: .date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text(entry.mood.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(entry.mood.color.opacity(0.2))
                        .foregroundStyle(entry.mood.color)
                        .clipShape(Capsule())
                }
                
                Text(entry.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(entry.content)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                
                HStack {
                    ForEach(entry.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(.systemGray6))
                            .clipShape(Capsule())
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 2)
        }
    }
}

// Models
struct JournalEntry: Identifiable {
    let id = UUID()
    let title: String
    let content: String
    let date: Date
    let mood: Mood
    let tags: [String]
}

enum Mood: String {
    case great = "Great"
    case good = "Good"
    case okay = "Okay"
    case bad = "Bad"
    
    var color: Color {
        switch self {
        case .great: return .green
        case .good: return .blue
        case .okay: return .orange
        case .bad: return .red
        }
    }
}

// Sample Data
let sampleEntries = [
    JournalEntry(
        title: "Morning Reflection",
        content: "Started the day with a peaceful meditation session. Feeling centered and ready for the day ahead. The morning light was particularly beautiful today.",
        date: Date(),
        mood: .great,
        tags: ["Morning", "Meditation"]
    ),
    JournalEntry(
        title: "Afternoon Thoughts",
        content: "Had a challenging meeting but managed to stay focused and calm. Practiced deep breathing when feeling stressed.",
        date: Date().addingTimeInterval(-86400),
        mood: .good,
        tags: ["Work", "Stress Management"]
    ),
    JournalEntry(
        title: "Evening Review",
        content: "Reflecting on today's accomplishments. Grateful for the small wins and learning opportunities.",
        date: Date().addingTimeInterval(-172800),
        mood: .okay,
        tags: ["Gratitude", "Evening"]
    )
]

#Preview {
    JournalView()
} 