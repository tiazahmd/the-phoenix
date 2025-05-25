import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Today's Progress") {
                    ProgressCard()
                }
                
                Section("Recent Activities") {
                    ActivityCard(title: "Morning Meditation", type: "Exercise", duration: "15 min")
                    ActivityCard(title: "Gratitude Journal", type: "Reflection", duration: "5 min")
                }
                
                Section("Upcoming") {
                    UpcomingCard(title: "Evening Reflection", time: "8:00 PM")
                    UpcomingCard(title: "Weekly Review", time: "Tomorrow")
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

struct UpcomingCard: View {
    let title: String
    let time: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                
                Text(time)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    DashboardView()
} 