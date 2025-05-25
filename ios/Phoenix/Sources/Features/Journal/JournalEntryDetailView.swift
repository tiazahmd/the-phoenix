import SwiftUI

struct JournalEntryDetailView: View {
    let entry: JournalEntry
    @State private var showingEditSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(entry.date, style: .date)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Text(entry.mood.rawValue)
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(entry.mood.color.opacity(0.2))
                            .foregroundStyle(entry.mood.color)
                            .clipShape(Capsule())
                    }
                    
                    Text(entry.title)
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding(.horizontal)
                
                // Content
                Text(entry.content)
                    .font(.body)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Tags
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(entry.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.subheadline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(.systemGray6))
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Insights
                VStack(alignment: .leading, spacing: 16) {
                    Text("Insights")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        InsightRow(
                            icon: "brain.head.profile",
                            title: "Emotional State",
                            description: "Your mood has been consistently positive this week."
                        )
                        
                        InsightRow(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "Progress",
                            description: "You've maintained a regular journaling habit for 7 days."
                        )
                        
                        InsightRow(
                            icon: "sparkles",
                            title: "Suggestion",
                            description: "Consider adding more specific details about what made your day great."
                        )
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Related Entries
                VStack(alignment: .leading, spacing: 16) {
                    Text("Related Entries")
                        .font(.headline)
                    
                    ForEach(sampleEntries.prefix(2)) { entry in
                        NavigationLink(destination: JournalEntryDetailView(entry: entry)) {
                            RelatedEntryRow(entry: entry)
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        showingEditSheet = true
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive) {
                        // Handle delete
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundStyle(.indigo)
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            // TODO: Implement edit view
        }
    }
}

struct InsightRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.indigo)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct RelatedEntryRow: View {
    let entry: JournalEntry
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(entry.date, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        JournalEntryDetailView(
            entry: JournalEntry(
                title: "Morning Reflection",
                content: "Started the day with a peaceful meditation session. Feeling centered and ready for the day ahead. The morning light was particularly beautiful today.",
                date: Date(),
                mood: .great,
                tags: ["Morning", "Meditation"]
            )
        )
    }
} 