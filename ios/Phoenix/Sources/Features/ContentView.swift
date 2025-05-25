import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CheckInView()
                .tabItem {
                    Label("Check-In", systemImage: "heart.text.square.fill")
                }
            
            QuizView()
                .tabItem {
                    Label("Quiz", systemImage: "questionmark.circle.fill")
                }
            
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.fill")
                }
            
            UrgeBusterView()
                .tabItem {
                    Label("Urge Buster", systemImage: "shield.fill")
                }
            
            TipsView()
                .tabItem {
                    Label("Tips", systemImage: "lightbulb.fill")
                }
        }
        .tint(.indigo)
    }
}

// Preview provider
#Preview {
    ContentView()
} 