import SwiftUI

struct ModernMoodSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    
    private let moodEmojis = ["😢", "😟", "😐", "🙂", "😊"]
    private let moodColors = [Color.phoenixDanger, Color.phoenixWarning, Color.phoenixTextSecondary, Color.phoenixSuccess, Color.phoenixPrimary]
    
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging = false
    
    private var normalizedValue: Double {
        (value - range.lowerBound) / (range.upperBound - range.lowerBound)
    }
    
    private var currentEmojiIndex: Int {
        min(Int(value - 1) / 2, 4)
    }
    
    private var currentColor: Color {
        moodColors[currentEmojiIndex]
    }
    
    var body: some View {
        VStack(spacing: Spacing.lg) {
            // Emoji Display
            Text(moodEmojis[currentEmojiIndex])
                .font(.system(size: 60))
                .scaleEffect(isDragging ? 1.2 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isDragging)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: currentEmojiIndex)
            
            // Custom Slider Track
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background Track
                    RoundedRectangle(cornerRadius: CornerRadius.pill)
                        .fill(Color.phoenixSurfaceLight)
                        .frame(height: 12)
                    
                    // Active Track
                    RoundedRectangle(cornerRadius: CornerRadius.pill)
                        .fill(
                            LinearGradient(
                                colors: [currentColor.opacity(0.6), currentColor],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * normalizedValue, height: 12)
                        .animation(.easeInOut(duration: 0.2), value: normalizedValue)
                    
                    // Thumb
                    ZStack {
                        Circle()
                            .fill(Color.phoenixCardBackground)
                            .frame(width: 32, height: 32)
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                        
                        Circle()
                            .fill(currentColor)
                            .frame(width: 20, height: 20)
                    }
                    .scaleEffect(isDragging ? 1.2 : 1.0)
                    .offset(x: geometry.size.width * normalizedValue - 16)
                    .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isDragging)
                    .animation(.easeInOut(duration: 0.2), value: normalizedValue)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                if !isDragging {
                                    isDragging = true
                                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                                    impactFeedback.impactOccurred()
                                }
                                
                                let newValue = gesture.location.x / geometry.size.width
                                let clampedValue = max(0, min(1, newValue))
                                let scaledValue = range.lowerBound + clampedValue * (range.upperBound - range.lowerBound)
                                let steppedValue = round(scaledValue / step) * step
                                
                                if abs(steppedValue - value) >= step {
                                    value = steppedValue
                                    let selectionFeedback = UISelectionFeedbackGenerator()
                                    selectionFeedback.selectionChanged()
                                }
                            }
                            .onEnded { _ in
                                isDragging = false
                            }
                    )
                }
            }
            .frame(height: 32)
            
            // Value Labels
            HStack {
                ForEach(Array(stride(from: range.lowerBound, through: range.upperBound, by: 2)), id: \.self) { tickValue in
                    VStack(spacing: Spacing.xs) {
                        Text("\(Int(tickValue))")
                            .font(.phoenixCaption)
                            .foregroundColor(abs(tickValue - value) < 1 ? currentColor : .phoenixTextTertiary)
                            .fontWeight(abs(tickValue - value) < 1 ? .bold : .medium)
                        
                        Circle()
                            .fill(abs(tickValue - value) < 1 ? currentColor : Color.phoenixSurfaceLight)
                            .frame(width: 6, height: 6)
                    }
                    .scaleEffect(abs(tickValue - value) < 1 ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: value)
                    
                    if tickValue != range.upperBound {
                        Spacer()
                    }
                }
            }
        }
    }
}

struct ModernUrgeSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    
    @State private var isDragging = false
    
    private var normalizedValue: Double {
        (value - range.lowerBound) / (range.upperBound - range.lowerBound)
    }
    
    private var currentColor: Color {
        if value <= 3 { return .phoenixSuccess }
        else if value <= 6 { return .phoenixWarning }
        else { return .phoenixDanger }
    }
    
    var body: some View {
        VStack(spacing: Spacing.lg) {
            // Progress Ring Display
            ZStack {
                PhoenixProgressRing(
                    progress: normalizedValue,
                    size: 120,
                    lineWidth: 12,
                    color: currentColor
                )
                
                VStack(spacing: Spacing.xs) {
                    Text("\(Int(value))")
                        .font(.phoenixTitle1)
                        .foregroundColor(currentColor)
                        .fontWeight(.bold)
                        .scaleEffect(isDragging ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isDragging)
                    
                    Text("out of 10")
                        .font(.phoenixCaption)
                        .foregroundColor(.phoenixTextSecondary)
                }
            }
            
            // Custom Slider Track
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background Track with gradient
                    RoundedRectangle(cornerRadius: CornerRadius.pill)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.phoenixSuccess.opacity(0.3),
                                    Color.phoenixWarning.opacity(0.3),
                                    Color.phoenixDanger.opacity(0.3)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 12)
                    
                    // Active Track
                    RoundedRectangle(cornerRadius: CornerRadius.pill)
                        .fill(currentColor)
                        .frame(width: geometry.size.width * normalizedValue, height: 12)
                        .animation(.easeInOut(duration: 0.2), value: normalizedValue)
                    
                    // Thumb
                    ZStack {
                        Circle()
                            .fill(Color.phoenixCardBackground)
                            .frame(width: 32, height: 32)
                            .shadow(color: currentColor.opacity(0.4), radius: 6, x: 0, y: 3)
                        
                        Circle()
                            .fill(currentColor)
                            .frame(width: 20, height: 20)
                    }
                    .scaleEffect(isDragging ? 1.3 : 1.0)
                    .offset(x: geometry.size.width * normalizedValue - 16)
                    .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isDragging)
                    .animation(.easeInOut(duration: 0.2), value: normalizedValue)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                if !isDragging {
                                    isDragging = true
                                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                                    impactFeedback.impactOccurred()
                                }
                                
                                let newValue = gesture.location.x / geometry.size.width
                                let clampedValue = max(0, min(1, newValue))
                                let scaledValue = range.lowerBound + clampedValue * (range.upperBound - range.lowerBound)
                                let steppedValue = round(scaledValue / step) * step
                                
                                if abs(steppedValue - value) >= step {
                                    value = steppedValue
                                    let selectionFeedback = UISelectionFeedbackGenerator()
                                    selectionFeedback.selectionChanged()
                                }
                            }
                            .onEnded { _ in
                                isDragging = false
                            }
                    )
                }
            }
            .frame(height: 32)
            
            // Intensity Labels
            HStack {
                Text("None")
                    .font(.phoenixCaption)
                    .foregroundColor(value <= 2 ? .phoenixSuccess : .phoenixTextTertiary)
                    .fontWeight(value <= 2 ? .bold : .medium)
                
                Spacer()
                
                Text("Moderate")
                    .font(.phoenixCaption)
                    .foregroundColor(value > 3 && value <= 7 ? .phoenixWarning : .phoenixTextTertiary)
                    .fontWeight(value > 3 && value <= 7 ? .bold : .medium)
                
                Spacer()
                
                Text("Intense")
                    .font(.phoenixCaption)
                    .foregroundColor(value > 7 ? .phoenixDanger : .phoenixTextTertiary)
                    .fontWeight(value > 7 ? .bold : .medium)
            }
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        ModernMoodSlider(value: .constant(7), range: 1...10, step: 1)
        ModernUrgeSlider(value: .constant(4), range: 1...10, step: 1)
    }
    .padding()
} 