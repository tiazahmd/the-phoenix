import SwiftUI

struct PhoenixTabView: View {
    @State private var selectedTab = 0
    @State private var animateTab = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Tab Content with proper padding
            Group {
                switch selectedTab {
                case 0:
                    CheckInView()
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case 1:
                    QuizView()
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case 2:
                    DashboardView()
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case 3:
                    UrgeBusterView()
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case 4:
                    TipsView()
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                default:
                    DashboardView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .animation(.easeInOut(duration: 0.3), value: selectedTab)
            
            // Custom Tab Bar
            PhoenixCustomTabBar(selectedTab: $selectedTab)
        }
        .background(Color.phoenixBackground)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct PhoenixCustomTabBar: View {
    @Binding var selectedTab: Int
    
    private let tabs = [
        TabItem(icon: "heart.circle.fill", title: "Check-In", color: .phoenixPrimary),
        TabItem(icon: "brain.head.profile", title: "Quiz", color: .phoenixSuccess),
        TabItem(icon: "chart.line.uptrend.xyaxis.circle.fill", title: "Dashboard", color: .phoenixPrimary),
        TabItem(icon: "shield.lefthalf.filled", title: "Urge Buster", color: .phoenixWarning),
        TabItem(icon: "lightbulb.circle.fill", title: "Tips", color: .phoenixPrimaryLight)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Top indicator line
            HStack(spacing: 0) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    Rectangle()
                        .fill(selectedTab == index ? Color.phoenixPrimary : Color.clear)
                        .frame(height: 4)
                        .frame(maxWidth: .infinity)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: selectedTab)
                }
            }
            
            // Tab buttons
            HStack(spacing: 0) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    TabBarButton(
                        tab: tabs[index],
                        isSelected: selectedTab == index,
                        action: {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                selectedTab = index
                            }
                            
                            // Haptic feedback
                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                            impactFeedback.impactOccurred()
                        }
                    )
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, Spacing.md)
            .padding(.top, Spacing.md)
            .padding(.bottom, Spacing.lg)
        }
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.xl)
                .fill(Color.phoenixCardBackground)
                .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: -5)
        )
    }
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.xs) {
                ZStack {
                    // Background circle for selected state
                    Circle()
                        .fill(tab.color.opacity(0.15))
                        .frame(width: 50, height: 50)
                        .scaleEffect(isSelected ? 1.0 : 0.8)
                        .opacity(isSelected ? 1.0 : 0.0)
                    
                    // Icon
                    Image(systemName: tab.icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(isSelected ? tab.color : .phoenixTextTertiary)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                }
                
                // Title
                Text(tab.title)
                    .font(.phoenixCaption)
                    .foregroundColor(isSelected ? tab.color : .phoenixTextTertiary)
                    .fontWeight(isSelected ? .semibold : .medium)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
    }
}

struct TabItem {
    let icon: String
    let title: String
    let color: Color
}

#Preview {
    PhoenixTabView()
        .environmentObject(AuthenticationManager())
} 