import SwiftUI

struct AudioExerciseView: View {
    @State private var isPlaying = false
    @State private var progress: Double = 0
    @State private var selectedTheme: AudioTheme = .breathing
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Theme Selection
                VStack(alignment: .leading, spacing: 16) {
                    Text("Choose Exercise Type")
                        .font(.headline)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(AudioTheme.allCases) { theme in
                                ThemeButton(
                                    theme: theme,
                                    isSelected: selectedTheme == theme
                                ) {
                                    selectedTheme = theme
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 2)
                
                // Audio Player
                VStack(spacing: 20) {
                    Image(systemName: selectedTheme.icon)
                        .font(.system(size: 80))
                        .foregroundStyle(selectedTheme.color)
                    
                    Text(selectedTheme.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("2-3 minute guided exercise")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    // Progress
                    VStack(spacing: 8) {
                        ProgressView(value: progress)
                            .tint(selectedTheme.color)
                        
                        HStack {
                            Text("0:00")
                            Spacer()
                            Text("2:30")
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    
                    // Controls
                    Button {
                        isPlaying.toggle()
                        if isPlaying {
                            startAudioExercise()
                        }
                    } label: {
                        Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 64))
                            .foregroundStyle(selectedTheme.color)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 2)
                
                Spacer()
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Audio Exercise")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func startAudioExercise() {
        // TODO: Implement API call to POST /exercises/audio?theme=...
        // TODO: Implement TTS audio playback
        
        // Simulate progress
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if progress < 1.0 && isPlaying {
                progress += 0.01
            } else {
                timer.invalidate()
                if progress >= 1.0 {
                    isPlaying = false
                    progress = 0
                }
            }
        }
    }
}

struct ThemeButton: View {
    let theme: AudioTheme
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: theme.icon)
                    .font(.title2)
                    .foregroundStyle(isSelected ? .white : theme.color)
                
                Text(theme.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(isSelected ? .white : .primary)
            }
            .frame(width: 80, height: 80)
            .background(isSelected ? theme.color : Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

enum AudioTheme: String, CaseIterable, Identifiable {
    case breathing = "breathing"
    case mindfulness = "mindfulness"
    case grounding = "grounding"
    case motivation = "motivation"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .breathing: return "Breathing"
        case .mindfulness: return "Mindfulness"
        case .grounding: return "Grounding"
        case .motivation: return "Motivation"
        }
    }
    
    var icon: String {
        switch self {
        case .breathing: return "lungs.fill"
        case .mindfulness: return "brain.head.profile"
        case .grounding: return "leaf.fill"
        case .motivation: return "bolt.heart.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .breathing: return .blue
        case .mindfulness: return .green
        case .grounding: return .brown
        case .motivation: return .orange
        }
    }
}

#Preview {
    AudioExerciseView()
} 