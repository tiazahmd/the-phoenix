import SwiftUI

struct DomainCard: View {
    let domain: InterestDomain
    let delay: Double
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.md) {
                ZStack {
                    Circle()
                        .fill(domain.color.opacity(0.2))
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: domain.icon)
                        .font(.title)
                        .foregroundColor(domain.color)
                }
                
                VStack(spacing: Spacing.xs) {
                    Text(domain.displayName)
                        .font(.phoenixHeadline)
                        .foregroundColor(.phoenixTextPrimary)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    
                    Text(domain.description)
                        .font(.phoenixCaption)
                        .foregroundColor(.phoenixTextSecondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
            .padding(Spacing.lg)
            .frame(height: 160)
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.lg)
                    .fill(Color.phoenixCardBackground)
                    .shadow(color: domain.color.opacity(0.2), radius: 8, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.lg)
                    .stroke(domain.color.opacity(0.3), lineWidth: 1)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    DomainCard(
        domain: .techTrivia,
        delay: 0.0
    ) {
        print("Domain selected")
    }
    .padding()
} 