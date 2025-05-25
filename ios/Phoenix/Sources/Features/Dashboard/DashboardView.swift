import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Today's Progress") {
                    ProgressCard()
                }
                
                Section("Recent Activities") {
                    ActivityCard(title: "Daily Quiz", type: "Tech Trivia", duration: "5 questions")
                    ActivityCard(title: "Check-In", type: "Mood: 7/10", duration: "2 min ago")
                    ActivityCard(title: "Urge Buster", type: "Cold Water Timer", duration: "3 min")
                }
                
                Section("Quick Actions") {
                    NavigationLink(destination: CheckInView()) {
                        QuickActionRow(title: "Quick Check-In", icon: "heart.text.square.fill", color: .blue)
                    }
                    NavigationLink(destination: UrgeBusterView()) {
                        QuickActionRow(title: "Urge Buster", icon: "shield.fill", color: .red)
                    }
                    NavigationLink(destination: QuizView()) {
                        QuickActionRow(title: "Take Quiz", icon: "questionmark.circle.fill", color: .indigo)
                    }
                }
                
                Section("Streaks & Metrics") {
                    StreakCard(title: "Check-In Streak", value: "7 days", icon: "flame.fill", color: .orange)
                    StreakCard(title: "Quiz Streak", value: "3 days", icon: "brain.head.profile", color: .purple)
                    StreakCard(title: "Urge-Free Days", value: "12 days", icon: "checkmark.shield.fill", color: .green)
                }
            }
            .navigationTitle("Dashboard")
        }
    }
}

struct ProgressCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("85%")
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundStyle(.indigo)
                
                Spacer()
                
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.title2)
                    .foregroundStyle(.indigo)
            }
            
            ProgressView(value: 0.85)
                .tint(.indigo)
            
            Text("You're making great progress!")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)
    }
}

struct ActivityCard: View {
    let title: String
    let type: String
    let duration: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                
                Text(type)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text(duration)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

struct QuickActionRow: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
                .frame(width: 32)
            
            Text(title)
                .font(.headline)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
    }
}

struct StreakCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(value)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(color)
            }
            
            Spacer()
        }
    }
}

#Preview {
    DashboardView()
} 