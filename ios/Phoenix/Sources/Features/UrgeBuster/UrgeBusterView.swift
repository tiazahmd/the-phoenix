import SwiftUI

struct UrgeBusterView: View {
    @State private var selectedTool: UrgeBusterTool?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Urge Buster")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Quick tools to help you through difficult moments")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top)
                    
                    // Emergency Message
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.orange)
                            Text("Feeling an urge right now?")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        
                        Text("Choose a tool below to help you get through this moment. You've got this!")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .background(.orange.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    // Tools Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(UrgeBusterTool.allCases) { tool in
                            UrgeBusterToolCard(tool: tool) {
                                selectedTool = tool
                            }
                        }
                    }
                    
                    // Quick Check-in
                    VStack(alignment: .leading, spacing: 16) {
                        Text("After using a tool")
                            .font(.headline)
                        
                        Text("Take a moment to check in with yourself and see how you're feeling.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        NavigationLink(destination: CheckInView()) {
                            HStack {
                                Image(systemName: "heart.text.square.fill")
                                Text("Quick Check-In")
                            }
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.indigo)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
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
            .navigationTitle("Urge Buster")
            .sheet(item: $selectedTool) { tool in
                UrgeBusterToolView(tool: tool) {
                    selectedTool = nil
                }
            }
        }
    }
}

struct UrgeBusterToolCard: View {
    let tool: UrgeBusterTool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: tool.icon)
                    .font(.system(size: 32))
                    .foregroundStyle(tool.color)
                
                Text(tool.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                Text(tool.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemBackground))
            .foregroundStyle(.primary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 2)
        }
    }
}

enum UrgeBusterTool: String, CaseIterable, Identifiable {
    case quickPuzzle = "quick_puzzle"
    case coldWaterTimer = "cold_water_timer"
    case twoFactorPrompt = "two_factor_prompt"
    case safetyCheck = "safety_check"
    case memoryFlashback = "memory_flashback"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .quickPuzzle: return "Quick Puzzle"
        case .coldWaterTimer: return "Cold Water Timer"
        case .twoFactorPrompt: return "Two-Factor Prompt"
        case .safetyCheck: return "Safety Check"
        case .memoryFlashback: return "Memory Flashback"
        }
    }
    
    var description: String {
        switch self {
        case .quickPuzzle: return "Distract your mind with a quick puzzle"
        case .coldWaterTimer: return "Use cold water to reset your system"
        case .twoFactorPrompt: return "Double-check your decision"
        case .safetyCheck: return "Random safety reminder"
        case .memoryFlashback: return "Remember why you started"
        }
    }
    
    var icon: String {
        switch self {
        case .quickPuzzle: return "puzzlepiece.fill"
        case .coldWaterTimer: return "drop.fill"
        case .twoFactorPrompt: return "checkmark.shield.fill"
        case .safetyCheck: return "shield.lefthalf.filled"
        case .memoryFlashback: return "brain.head.profile"
        }
    }
    
    var color: Color {
        switch self {
        case .quickPuzzle: return .blue
        case .coldWaterTimer: return .cyan
        case .twoFactorPrompt: return .green
        case .safetyCheck: return .orange
        case .memoryFlashback: return .purple
        }
    }
}

#Preview {
    UrgeBusterView()
} 