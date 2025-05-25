import SwiftUI

struct NewJournalEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var content = ""
    @State private var selectedMood: Mood = .good
    @State private var selectedTags: Set<String> = []
    @State private var newTag = ""
    @State private var showingTagInput = false
    
    let availableTags = [
        "Morning", "Afternoon", "Evening",
        "Meditation", "Exercise", "Work",
        "Gratitude", "Goals", "Reflection",
        "Stress Management", "Personal Growth"
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $title)
                    
                    MoodPicker(selectedMood: $selectedMood)
                }
                
                Section("Content") {
                    TextEditor(text: $content)
                        .frame(minHeight: 100)
                }
                
                Section("Tags") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(Array(selectedTags), id: \.self) { tag in
                                TagView(tag: tag) {
                                    selectedTags.remove(tag)
                                }
                            }
                            
                            Button {
                                showingTagInput = true
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundStyle(.indigo)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    
                    if showingTagInput {
                        HStack {
                            TextField("Add tag", text: $newTag)
                                .textFieldStyle(.roundedBorder)
                            
                            Button("Add") {
                                if !newTag.isEmpty {
                                    selectedTags.insert(newTag)
                                    newTag = ""
                                    showingTagInput = false
                                }
                            }
                            .disabled(newTag.isEmpty)
                        }
                    }
                    
                    if !showingTagInput {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(availableTags.filter { !selectedTags.contains($0) }, id: \.self) { tag in
                                    Button {
                                        selectedTags.insert(tag)
                                    } label: {
                                        Text(tag)
                                            .font(.caption)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color(.systemGray6))
                                            .foregroundStyle(.primary)
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveEntry()
                    }
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }
        }
    }
    
    private func saveEntry() {
        // TODO: Implement save functionality
        dismiss()
    }
}

struct MoodPicker: View {
    @Binding var selectedMood: Mood
    
    var body: some View {
        HStack {
            Text("Mood")
            
            Spacer()
            
            ForEach([Mood.great, .good, .okay, .bad], id: \.self) { mood in
                Button {
                    selectedMood = mood
                } label: {
                    Text(mood.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(mood == selectedMood ? mood.color.opacity(0.2) : Color.clear)
                        .foregroundStyle(mood == selectedMood ? mood.color : .secondary)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .strokeBorder(mood == selectedMood ? mood.color : .clear)
                        )
                }
            }
        }
    }
}

struct TagView: View {
    let tag: String
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(tag)
                .font(.caption)
            
            Button {
                onRemove()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(.systemGray6))
        .clipShape(Capsule())
    }
}

#Preview {
    NewJournalEntryView()
} 