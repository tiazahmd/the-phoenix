import SwiftUI

struct LoginView: View {
    @StateObject private var authManager = AuthenticationManager()
    @State private var username = ""
    @State private var password = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                // Logo/Header
                VStack(spacing: 16) {
                    Image(systemName: "phoenix.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(.indigo)
                    
                    Text("Phoenix")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Personal Recovery Companion")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 40)
                
                // Login Form
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Username")
                            .font(.headline)
                        
                        TextField("Enter your username", text: $username)
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.headline)
                        
                        SecureField("Enter your password", text: $password)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    Button {
                        login()
                    } label: {
                        HStack {
                            if authManager.isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .tint(.white)
                            }
                            Text(authManager.isLoading ? "Signing In..." : "Sign In")
                        }
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.indigo)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(authManager.isLoading || username.isEmpty || password.isEmpty)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Footer
                VStack(spacing: 8) {
                    Text("Personal Use Only")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("This app is designed for individual recovery support")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom)
            }
            .padding()
            .navigationBarHidden(true)
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
    }
    
    private func login() {
        authManager.login(username: username, password: password)
    }
}

#Preview {
    LoginView()
} 