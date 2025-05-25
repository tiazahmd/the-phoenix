import Foundation
import Combine

@MainActor
class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiClient = APIClient.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Check if user is already logged in
        checkAuthenticationStatus()
    }
    
    func login(username: String, password: String) {
        print("🔐 Starting login for username: \(username)")
        isLoading = true
        errorMessage = nil
        
        let loginRequest = LoginRequest(username: username, password: password)
        
        apiClient.login(loginRequest)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    print("🔄 Login completion received")
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        print("❌ Login error: \(error)")
                        if let decodingError = error as? DecodingError {
                            print("❌ Decoding error details: \(decodingError)")
                            self?.errorMessage = "Invalid response format: \(decodingError.localizedDescription)"
                        } else {
                            self?.errorMessage = error.localizedDescription
                        }
                    }
                },
                receiveValue: { [weak self] response in
                    print("✅ Login response received successfully")
                    self?.handleLoginSuccess(response)
                }
            )
            .store(in: &cancellables)
    }
    
    func logout() {
        apiClient.logout()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] _ in
                    self?.handleLogout()
                }
            )
            .store(in: &cancellables)
    }
    
    private func handleLoginSuccess(_ response: LoginResponse) {
        print("🎉 Login successful! Setting isAuthenticated = true")
        
        // Convert UserResponse to User for local storage
        let user = User(
            id: UUID(uuidString: response.user.id) ?? UUID(), // Use server UUID or generate new one
            username: response.user.username,
            email: response.user.email,
            firstName: response.user.firstName,
            lastName: response.user.lastName,
            avatar: response.user.avatar,
            bio: response.user.bio,
            dateOfBirth: response.user.dateOfBirth,
            timezone: response.user.timezone,
            notificationPreferences: response.user.notificationPreferences?.mapValues { $0.value as? String ?? "" },
            profile: response.user.profile?.progressPoints.description
        )
        
        self.currentUser = user
        self.isAuthenticated = true
        print("✅ isAuthenticated set to: \(self.isAuthenticated)")
        print("✅ currentUser set to: \(user.username)")
        
        // Store session for persistence
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.set(user.id.uuidString, forKey: "userId")
        UserDefaults.standard.set(response.user.id, forKey: "serverUserId") // Store server ID separately
    }
    
    private func handleLogout() {
        currentUser = nil
        isAuthenticated = false
        
        // Clear stored session
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "userId")
    }
    
    private func checkAuthenticationStatus() {
        // Simple session check - in a real app you'd validate with the server
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        if isLoggedIn {
            // For simplicity, we'll just set authenticated state
            // In a real app, you'd fetch user data from the server
            isAuthenticated = true
        }
    }
    
    // MARK: - Testing Helper
    func forceLogout() {
        handleLogout()
    }
}

// MARK: - Data Models

struct User: Codable, Identifiable {
    let id: UUID
    let username: String
    let email: String
    let firstName: String
    let lastName: String
    let avatar: String?
    let bio: String?
    let dateOfBirth: String?
    let timezone: String?
    let notificationPreferences: [String: String]?
    let profile: String?
    
    enum CodingKeys: String, CodingKey {
        case id, username, email, avatar, bio, timezone, profile
        case firstName = "first_name"
        case lastName = "last_name"
        case dateOfBirth = "date_of_birth"
        case notificationPreferences = "notification_preferences"
    }
} 