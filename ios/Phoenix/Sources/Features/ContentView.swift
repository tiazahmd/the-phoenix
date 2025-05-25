import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var authManager: AuthenticationManager
    
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
        .overlay(alignment: .topTrailing) {
            Button("Logout") {
                authManager.forceLogout()
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(.red)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding()
        }
    }
}

// Preview provider
#Preview {
    ContentView()
} 