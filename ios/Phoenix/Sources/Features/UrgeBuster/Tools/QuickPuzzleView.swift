import SwiftUI

struct QuickPuzzleView: View {
    @State private var numbers = Array(1...8).shuffled() + [0]
    @State private var emptyIndex = 8
    @State private var moves = 0
    @State private var isCompleted = false
    
    private let targetNumbers = Array(1...8) + [0]
    
    var body: some View {
        PhoenixCard {
            VStack(spacing: Spacing.xl) {
                VStack(spacing: Spacing.md) {
                    Text("Sliding Puzzle")
                        .font(.phoenixTitle3)
                        .foregroundColor(.phoenixTextPrimary)
                    
                    Text("Focus your mind by solving this puzzle")
                        .font(.phoenixBody)
                        .foregroundColor(.phoenixTextSecondary)
                        .multilineTextAlignment(.center)
                    
                    HStack {
                        Text("Moves: \(moves)")
                            .font(.phoenixBodySecondary)
                            .foregroundColor(.phoenixTextSecondary)
                        
                        Spacer()
                        
                        Button("Reset") {
                            resetPuzzle()
                        }
                        .font(.phoenixBodySecondary)
                        .foregroundColor(.phoenixPrimary)
                    }
                }
                
                // Puzzle Grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                    ForEach(0..<9, id: \.self) { index in
                        PuzzleTile(
                            number: numbers[index],
                            isEmpty: numbers[index] == 0,
                            isCompleted: isCompleted
                        ) {
                            moveTile(at: index)
                        }
                    }
                }
                .padding(Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadius.md)
                        .fill(Color.phoenixSurfaceLight)
                )
                
                if isCompleted {
                    VStack(spacing: Spacing.sm) {
                        Text("🎉 Puzzle Completed!")
                            .font(.phoenixHeadline)
                            .foregroundColor(.phoenixSuccess)
                            .fontWeight(.bold)
                        
                        Text("Great job! You completed it in \(moves) moves.")
                            .font(.phoenixBody)
                            .foregroundColor(.phoenixTextSecondary)
                            .multilineTextAlignment(.center)
                    }
                }
            }
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.top, Spacing.lg)
    }
    
    private func moveTile(at index: Int) {
        guard !isCompleted else { return }
        
        let row = index / 3
        let col = index % 3
        let emptyRow = emptyIndex / 3
        let emptyCol = emptyIndex % 3
        
        // Check if tile is adjacent to empty space
        if (abs(row - emptyRow) == 1 && col == emptyCol) || (abs(col - emptyCol) == 1 && row == emptyRow) {
            numbers.swapAt(index, emptyIndex)
            emptyIndex = index
            moves += 1
            
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            
            // Check if completed
            if numbers == targetNumbers {
                isCompleted = true
                let notificationFeedback = UINotificationFeedbackGenerator()
                notificationFeedback.notificationOccurred(.success)
            }
        }
    }
    
    private func resetPuzzle() {
        numbers = Array(1...8).shuffled() + [0]
        emptyIndex = 8
        moves = 0
        isCompleted = false
    }
}

struct PuzzleTile: View {
    let number: Int
    let isEmpty: Bool
    let isCompleted: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(isEmpty ? "" : "\(number)")
                .font(.phoenixTitle3)
                .fontWeight(.bold)
                .foregroundColor(isEmpty ? .clear : .phoenixTextPrimary)
                .frame(width: 60, height: 60)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadius.sm)
                        .fill(isEmpty ? Color.clear : (isCompleted ? Color.phoenixSuccess.opacity(0.2) : Color.phoenixCardBackground))
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadius.sm)
                                .stroke(isEmpty ? Color.clear : Color.phoenixBorder, lineWidth: 1)
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isEmpty)
    }
}

#Preview {
    QuickPuzzleView()
} 