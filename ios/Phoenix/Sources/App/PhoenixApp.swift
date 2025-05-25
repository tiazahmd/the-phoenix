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
                        .onAppear {
                            print("📱 Showing ContentView - User is authenticated")
                        }
                } else {
                    LoginView()
                        .onAppear {
                            print("🔐 Showing LoginView - User not authenticated")
                        }
                }
            }
            .onChange(of: authManager.isAuthenticated) { oldValue, newValue in
                print("🔄 Authentication state changed: \(oldValue) → \(newValue)")
            }
            .environmentObject(authManager)
            .environmentObject(coreDataStack)
        }
    }
} 