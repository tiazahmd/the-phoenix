import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var streakCount = 7
    @State private var urgeFreeHours = 48
    @State private var completedCheckIns = 15
    @State private var completedQuizzes = 8
    @State private var currentXP = 1250
    @State private var nextLevelXP = 2000
    @State private var level = 5
    @State private var animateProgress = false
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: Spacing.lg) {
                // Header with greeting and level
                VStack(spacing: Spacing.md) {
                    HStack {
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            Text("Welcome back,")
                                .font(.phoenixBody)
                                .foregroundColor(.phoenixTextSecondary)
                            
                            Text(authManager.currentUser?.username.capitalized ?? "Phoenix User")
                                .font(.phoenixTitle2)
                                .foregroundColor(.phoenixTextPrimary)
                        }
                        
                        Spacer()
                        
                        // Logout Button
                        Button(action: {
                            authManager.forceLogout()
                        }) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.title3)
                                .foregroundColor(.phoenixDanger)
                        }
                        
                        // Profile avatar with level
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.phoenixPrimary, .phoenixPrimaryLight],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 60, height: 60)
                            
                            Text("\(level)")
                                .font(.phoenixTitle3)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                    }
                    
                    // Level Progress
                    PhoenixLevelProgress(
                        currentXP: currentXP,
                        nextLevelXP: nextLevelXP,
                        level: level
                    )
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.top, Spacing.md)
                
                // Streak and Stats Section
                PhoenixCard {
                    VStack(spacing: Spacing.lg) {
                        Text("Your Progress")
                            .font(.phoenixTitle3)
                            .foregroundColor(.phoenixTextPrimary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(spacing: Spacing.md) {
                            PhoenixStreakCounter(
                                count: streakCount,
                                icon: "flame.fill",
                                title: "Day Streak",
                                color: .phoenixWarning
                            )
                            
                            PhoenixStreakCounter(
                                count: urgeFreeHours,
                                icon: "shield.checkered",
                                title: "Urge-Free\nHours",
                                color: .phoenixSuccess
                            )
                            
                            PhoenixStreakCounter(
                                count: completedCheckIns,
                                icon: "heart.fill",
                                title: "Check-Ins",
                                color: .phoenixPrimary
                            )
                        }
                        
                        // Progress rings
                        HStack(spacing: Spacing.xl) {
                            VStack(spacing: Spacing.sm) {
                                PhoenixProgressRing(
                                    progress: animateProgress ? 0.75 : 0,
                                    size: 80,
                                    color: .phoenixPrimary
                                )
                                .overlay(
                                    Text("75%")
                                        .font(.phoenixBody)
                                        .fontWeight(.bold)
                                        .foregroundColor(.phoenixTextPrimary)
                                )
                                
                                Text("Daily Goal")
                                    .font(.phoenixCaption)
                                    .foregroundColor(.phoenixTextSecondary)
                            }
                            
                            VStack(spacing: Spacing.sm) {
                                PhoenixProgressRing(
                                    progress: animateProgress ? 0.9 : 0,
                                    size: 80,
                                    color: .phoenixSuccess
                                )
                                .overlay(
                                    Text("90%")
                                        .font(.phoenixBody)
                                        .fontWeight(.bold)
                                        .foregroundColor(.phoenixTextPrimary)
                                )
                                
                                Text("Weekly Goal")
                                    .font(.phoenixCaption)
                                    .foregroundColor(.phoenixTextSecondary)
                            }
                        }
                    }
                }
                .padding(.horizontal, Spacing.lg)
                
                // Quick Actions
                VStack(alignment: .leading, spacing: Spacing.md) {
                    Text("Quick Actions")
                        .font(.phoenixTitle3)
                        .foregroundColor(.phoenixTextPrimary)
                        .padding(.horizontal, Spacing.lg)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: Spacing.md) {
                            QuickActionCard(
                                title: "Daily Check-In",
                                subtitle: "How are you feeling today?",
                                icon: "heart.circle.fill",
                                gradient: [.phoenixPrimary, .phoenixPrimaryLight],
                                action: { /* Navigate to check-in */ }
                            )
                            
                            QuickActionCard(
                                title: "Take Quiz",
                                subtitle: "Test your knowledge",
                                icon: "brain.head.profile",
                                gradient: [.phoenixSuccess, Color.green.opacity(0.7)],
                                action: { /* Navigate to quiz */ }
                            )
                            
                            QuickActionCard(
                                title: "Urge Buster",
                                subtitle: "Need help right now?",
                                icon: "shield.lefthalf.filled",
                                gradient: [.phoenixWarning, Color.orange.opacity(0.7)],
                                action: { /* Navigate to urge buster */ }
                            )
                            
                            QuickActionCard(
                                title: "Browse Tips",
                                subtitle: "Learn something new",
                                icon: "lightbulb.circle.fill",
                                gradient: [.phoenixPrimaryLight, .phoenixPrimary.opacity(0.6)],
                                action: { /* Navigate to tips */ }
                            )
                        }
                        .padding(.horizontal, Spacing.lg)
                    }
                }
                
                // Achievements Section
                PhoenixCard {
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        HStack {
                            Text("Achievements")
                                .font(.phoenixTitle3)
                                .foregroundColor(.phoenixTextPrimary)
                            
                            Spacer()
                            
                            Button("View All") {
                                // Navigate to achievements
                            }
                            .font(.phoenixBodySecondary)
                            .foregroundColor(.phoenixPrimary)
                        }
                        
                        HStack(spacing: Spacing.md) {
                            PhoenixBadge(
                                title: "First Week",
                                icon: "star.fill",
                                isUnlocked: true,
                                color: .phoenixWarning
                            )
                            
                            PhoenixBadge(
                                title: "Quiz Master",
                                icon: "brain.head.profile",
                                isUnlocked: true,
                                color: .phoenixSuccess
                            )
                            
                            PhoenixBadge(
                                title: "Streak Hero",
                                icon: "flame.fill",
                                isUnlocked: false,
                                color: .phoenixPrimary
                            )
                            
                            PhoenixBadge(
                                title: "Wisdom",
                                icon: "lightbulb.fill",
                                isUnlocked: false,
                                color: .phoenixPrimaryLight
                            )
                        }
                    }
                }
                .padding(.horizontal, Spacing.lg)
                
                // Recent Activity
                PhoenixCard {
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        Text("Recent Activity")
                            .font(.phoenixTitle3)
                            .foregroundColor(.phoenixTextPrimary)
                        
                        VStack(spacing: Spacing.sm) {
                            ActivityRow(
                                title: "Completed daily check-in",
                                subtitle: "2 hours ago",
                                icon: "checkmark.circle.fill",
                                color: .phoenixSuccess
                            )
                            
                            ActivityRow(
                                title: "Finished Tech Trivia quiz",
                                subtitle: "Yesterday",
                                icon: "brain.head.profile",
                                color: .phoenixPrimary
                            )
                            
                            ActivityRow(
                                title: "Used breathing exercise",
                                subtitle: "2 days ago",
                                icon: "wind",
                                color: .phoenixPrimaryLight
                            )
                        }
                    }
                }
                .padding(.horizontal, Spacing.lg)
                
                // Bottom padding for tab bar
                Spacer(minLength: 100)
            }
            .padding(.vertical, Spacing.md)
        }
        .background(Color.phoenixBackground)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).delay(0.3)) {
                animateProgress = true
            }
        }
    }
}

struct QuickActionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let gradient: [Color]
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.md) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(.white)
                }
                
                VStack(spacing: Spacing.xs) {
                    Text(title)
                        .font(.phoenixBody)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text(subtitle)
                        .font(.phoenixCaption)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
            }
            .padding(Spacing.lg)
            .frame(width: 160, height: 140)
            .background(
                LinearGradient(
                    colors: gradient,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))
            .shadow(color: gradient.first?.opacity(0.3) ?? .clear, radius: 8, x: 0, y: 4)
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

struct ActivityRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: Spacing.md) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(title)
                    .font(.phoenixBody)
                    .foregroundColor(.phoenixTextPrimary)
                
                Text(subtitle)
                    .font(.phoenixCaption)
                    .foregroundColor(.phoenixTextSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.phoenixTextTertiary)
        }
        .padding(Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.md)
                .fill(Color.phoenixSurfaceLight)
        )
    }
}

#Preview {
    DashboardView()
        .environmentObject(AuthenticationManager())
} 