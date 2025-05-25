import SwiftUI

struct ProfileView: View {
    @State private var showingEditProfile = false
    @State private var showingSettings = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    ProfileHeader()
                    
                    // Stats
                    StatsGrid()
                    
                    // Achievements
                    AchievementsSection()
                    
                    // Recent Activity
                    RecentActivitySection()
                    
                    // Settings
                    SettingsSection(showingSettings: $showingSettings)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingEditProfile = true
                    } label: {
                        Image(systemName: "pencil.circle")
                            .foregroundStyle(.indigo)
                    }
                }
            }
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView()
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
    }
}

struct ProfileHeader: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.indigo)
            
            VStack(spacing: 8) {
                Text("John Doe")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Mindfulness Explorer")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text("Member since May 2025")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Text("On a journey to discover inner peace and personal growth through mindfulness and reflection.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}

struct StatsGrid: View {
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            StatItem(title: "Streak", value: "7", icon: "flame.fill")
            StatItem(title: "Minutes", value: "126", icon: "clock.fill")
            StatItem(title: "Exercises", value: "15", icon: "figure.mind.and.body")
            StatItem(title: "Entries", value: "28", icon: "book.fill")
            StatItem(title: "Points", value: "450", icon: "star.fill")
            StatItem(title: "Level", value: "3", icon: "chart.line.uptrend.xyaxis")
        }
    }
}

struct StatItem: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.indigo)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}

struct AchievementsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Achievements")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    AchievementCard(
                        icon: "star.circle.fill",
                        title: "Early Bird",
                        description: "Complete 5 morning exercises"
                    )
                    
                    AchievementCard(
                        icon: "flame.circle.fill",
                        title: "Streak Master",
                        description: "Maintain a 7-day streak"
                    )
                    
                    AchievementCard(
                        icon: "heart.circle.fill",
                        title: "Mindfulness Guru",
                        description: "Practice mindfulness for 100 minutes"
                    )
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct AchievementCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundStyle(.indigo)
            
            Text(title)
                .font(.headline)
            
            Text(description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(width: 120)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct RecentActivitySection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(.headline)
            
            ForEach(0..<3) { _ in
                ActivityRow()
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct ActivityRow: View {
    var body: some View {
        HStack {
            Image(systemName: "figure.mind.and.body")
                .font(.title2)
                .foregroundStyle(.indigo)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Completed Morning Meditation")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("10 minutes • 2 hours ago")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text("+10")
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.indigo.opacity(0.2))
                .foregroundStyle(.indigo)
                .clipShape(Capsule())
        }
    }
}

struct SettingsSection: View {
    @Binding var showingSettings: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.headline)
            
            Button {
                showingSettings = true
            } label: {
                HStack {
                    Image(systemName: "gear")
                        .font(.title2)
                        .foregroundStyle(.indigo)
                        .frame(width: 32)
                    
                    Text("App Settings")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .foregroundStyle(.primary)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    ProfileView()
} 