import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var username = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var animateGradient = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Animated gradient background
                LinearGradient(
                    colors: [
                        .phoenixPrimary.opacity(0.8),
                        .phoenixPrimaryLight.opacity(0.6),
                        .phoenixBackground
                    ],
                    startPoint: animateGradient ? .topLeading : .bottomTrailing,
                    endPoint: animateGradient ? .bottomTrailing : .topLeading
                )
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true), value: animateGradient)
                
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        Spacer(minLength: geometry.size.height * 0.1)
                        
                        // Hero Section
                        VStack(spacing: Spacing.lg) {
                            // Phoenix Logo with glow effect
                            ZStack {
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            colors: [.phoenixPrimary.opacity(0.3), .clear],
                                            center: .center,
                                            startRadius: 0,
                                            endRadius: 80
                                        )
                                    )
                                    .frame(width: 160, height: 160)
                                
                                Image(systemName: "phoenix.fill")
                                    .font(.system(size: 80, weight: .light))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.phoenixPrimary, .phoenixPrimaryDark],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: .phoenixPrimary.opacity(0.3), radius: 10, x: 0, y: 5)
                            }
                            
                            VStack(spacing: Spacing.sm) {
                                Text("Phoenix")
                                    .font(.phoenixTitle1)
                                    .foregroundColor(.phoenixTextPrimary)
                                
                                Text("Your Personal Recovery Companion")
                                    .font(.phoenixBody)
                                    .foregroundColor(.phoenixTextSecondary)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        
                        // Login Card
                        PhoenixCard {
                            VStack(spacing: Spacing.lg) {
                                Text("Welcome Back!")
                                    .font(.phoenixTitle3)
                                    .foregroundColor(.phoenixTextPrimary)
                                
                                VStack(spacing: Spacing.md) {
                                    // Username Field
                                    VStack(alignment: .leading, spacing: Spacing.sm) {
                                        Text("Username")
                                            .font(.phoenixBody)
                                            .foregroundColor(.phoenixTextPrimary)
                                        
                                        TextField("Enter your username", text: $username)
                                            .font(.phoenixBody)
                                            .padding(Spacing.md)
                                            .background(
                                                RoundedRectangle(cornerRadius: CornerRadius.md)
                                                    .fill(Color.phoenixSurfaceLight)
                                            )
                                            .textInputAutocapitalization(.never)
                                            .autocorrectionDisabled()
                                    }
                                    
                                    // Password Field
                                    VStack(alignment: .leading, spacing: Spacing.sm) {
                                        Text("Password")
                                            .font(.phoenixBody)
                                            .foregroundColor(.phoenixTextPrimary)
                                        
                                        SecureField("Enter your password", text: $password)
                                            .font(.phoenixBody)
                                            .padding(Spacing.md)
                                            .background(
                                                RoundedRectangle(cornerRadius: CornerRadius.md)
                                                    .fill(Color.phoenixSurfaceLight)
                                            )
                                    }
                                    
                                    // Login Button
                                    PhoenixButton(
                                        title: authManager.isLoading ? "Signing In..." : "Sign In",
                                        action: login,
                                        isLoading: authManager.isLoading,
                                        isDisabled: username.isEmpty || password.isEmpty
                                    )
                                    .padding(.top, Spacing.sm)
                                }
                            }
                        }
                        .padding(.horizontal, Spacing.lg)
                        
                        // Footer
                        VStack(spacing: Spacing.sm) {
                            HStack(spacing: Spacing.sm) {
                                Image(systemName: "lock.shield.fill")
                                    .foregroundColor(.phoenixPrimary)
                                Text("Personal Use Only")
                                    .font(.phoenixCaption)
                                    .foregroundColor(.phoenixTextSecondary)
                            }
                            
                            Text("This app is designed for individual recovery support")
                                .font(.phoenixCaption)
                                .foregroundColor(.phoenixTextTertiary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, Spacing.lg)
                        
                        Spacer(minLength: Spacing.xl)
                    }
                }
            }
        }
        .onAppear {
            animateGradient = true
        }
        .alert("Login Failed", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(authManager.errorMessage ?? "Please check your credentials and try again.")
        }
        .onChange(of: authManager.errorMessage) { _, newValue in
            if newValue != nil {
                showingAlert = true
            }
        }
    }
    
    private func login() {
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        authManager.login(username: username, password: password)
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthenticationManager())
} 