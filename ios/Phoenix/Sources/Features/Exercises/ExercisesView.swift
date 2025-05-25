import SwiftUI

struct ExercisesView: View {
    @State private var selectedCategory: ExerciseCategory = .mindfulness
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    CategoryPicker(selectedCategory: $selectedCategory)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(selectedCategory.exercises) { exercise in
                            ExerciseCard(exercise: exercise)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Exercises")
            .background(Color(.systemGroupedBackground))
        }
    }
}

struct ExerciseCard: View {
    let exercise: Exercise
    
    var body: some View {
        NavigationLink(destination: ExerciseDetailView(exercise: exercise)) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: exercise.icon)
                    .font(.title)
                    .foregroundStyle(.indigo)
                
                Text(exercise.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(exercise.duration)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 2)
        }
    }
}

struct CategoryPicker: View {
    @Binding var selectedCategory: ExerciseCategory
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(ExerciseCategory.allCases) { category in
                    CategoryButton(
                        title: category.title,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
        }
    }
}

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
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

// Models
enum ExerciseCategory: String, CaseIterable, Identifiable {
    case mindfulness
    case breathing
    case meditation
    case movement
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .mindfulness: return "Mindfulness"
        case .breathing: return "Breathing"
        case .meditation: return "Meditation"
        case .movement: return "Movement"
        }
    }
    
    var exercises: [Exercise] {
        switch self {
        case .mindfulness:
            return [
                Exercise(title: "Body Scan", duration: "10 min", icon: "figure.walk"),
                Exercise(title: "Mindful Walking", duration: "15 min", icon: "figure.walk"),
                Exercise(title: "Mindful Eating", duration: "10 min", icon: "cup.and.saucer.fill"),
                Exercise(title: "Sound Awareness", duration: "5 min", icon: "ear.fill")
            ]
        case .breathing:
            return [
                Exercise(title: "Box Breathing", duration: "5 min", icon: "square"),
                Exercise(title: "4-7-8 Breathing", duration: "10 min", icon: "lungs.fill"),
                Exercise(title: "Deep Breathing", duration: "5 min", icon: "wind"),
                Exercise(title: "Alternate Nostril", duration: "10 min", icon: "nose.fill")
            ]
        case .meditation:
            return [
                Exercise(title: "Loving Kindness", duration: "15 min", icon: "heart.fill"),
                Exercise(title: "Focused Attention", duration: "10 min", icon: "brain.head.profile"),
                Exercise(title: "Open Awareness", duration: "20 min", icon: "sparkles"),
                Exercise(title: "Body & Mind", duration: "15 min", icon: "figure.mind.and.body")
            ]
        case .movement:
            return [
                Exercise(title: "Morning Stretch", duration: "10 min", icon: "figure.mixed.cardio"),
                Exercise(title: "Desk Yoga", duration: "5 min", icon: "figure.yoga"),
                Exercise(title: "Quick Energizer", duration: "3 min", icon: "bolt.fill"),
                Exercise(title: "Mindful Walking", duration: "15 min", icon: "figure.walk")
            ]
        }
    }
}

struct Exercise: Identifiable {
    let id = UUID()
    let title: String
    let duration: String
    let icon: String
}

#Preview {
    ExercisesView()
} 