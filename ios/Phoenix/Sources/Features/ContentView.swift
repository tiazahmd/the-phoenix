import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var authManager: AuthenticationManager
    
    var body: some View {
        PhoenixTabView()
            .onAppear {
                print("📱 ContentView appeared successfully!")
            }
    }
}

// Preview provider
#Preview {
    ContentView()
        .environmentObject(AuthenticationManager())
} 