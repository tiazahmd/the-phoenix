import SwiftUI

struct ExerciseDetailView: View {
    let exercise: Exercise
    @State private var isPlaying = false
    @State private var progress: Double = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: exercise.icon)
                        .font(.system(size: 60))
                        .foregroundStyle(.indigo)
                    
                    Text(exercise.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(exercise.duration)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 32)
                
                // Progress
                VStack(spacing: 8) {
                    ProgressView(value: progress)
                        .tint(.indigo)
                    
                    HStack {
                        Text("0:00")
                        Spacer()
                        Text(exercise.duration)
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding(.horizontal)
                
                // Controls
                HStack(spacing: 40) {
                    Button {
                        // Previous
                    } label: {
                        Image(systemName: "backward.fill")
                            .font(.title)
                            .foregroundStyle(.secondary)
                    }
                    
                    Button {
                        isPlaying.toggle()
                    } label: {
                        Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 64))
                            .foregroundStyle(.indigo)
                    }
                    
                    Button {
                        // Next
                    } label: {
                        Image(systemName: "forward.fill")
                            .font(.title)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 32)
                
                // Description
                VStack(alignment: .leading, spacing: 16) {
                    Text("Description")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("This exercise helps you develop mindfulness and awareness through guided practice. Follow the audio instructions and take time to focus on your experience.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Benefits
                VStack(alignment: .leading, spacing: 16) {
                    Text("Benefits")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        BenefitRow(icon: "brain.head.profile", text: "Improves focus and concentration")
                        BenefitRow(icon: "heart.fill", text: "Reduces stress and anxiety")
                        BenefitRow(icon: "zzz", text: "Enhances sleep quality")
                        BenefitRow(icon: "bolt.heart", text: "Boosts energy levels")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
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
                Button {
                    // Add to favorites
                } label: {
                    Image(systemName: "heart")
                        .foregroundStyle(.indigo)
                }
            }
        }
    }
}

struct BenefitRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.indigo)
                .frame(width: 32)
            
            Text(text)
                .font(.body)
                .foregroundStyle(.primary)
        }
    }
}

#Preview {
    NavigationStack {
        ExerciseDetailView(
            exercise: Exercise(
                title: "Morning Meditation",
                duration: "10 min",
                icon: "sun.max.fill"
            )
        )
    }
} 