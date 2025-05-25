import SwiftUI

@main
struct PhoenixApp: App {
    @StateObject private var authManager = AuthenticationManager()
    @StateObject private var coreDataStack = CoreDataStack.shared
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authManager.isAuthenticated {
                    ContentView()
                        .environment(\.managedObjectContext, coreDataStack.context)
                } else {
                    LoginView()
                }
            }
            .environmentObject(authManager)
            .environmentObject(coreDataStack)
        }
    }
} 