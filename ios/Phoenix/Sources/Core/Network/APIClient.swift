import Foundation
import Combine

class APIClient {
    static let shared = APIClient()
    
    private let baseURL = URL(string: "http://127.0.0.1:8000/api/v1")!
    private let session = URLSession.shared
    
    private init() {
        // Clear any cached cookies on app start for clean authentication
        clearCookies()
    }
    
    private func clearCookies() {
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }
    
    // MARK: - Authentication
    
    func login(_ request: LoginRequest) -> AnyPublisher<LoginResponse, Error> {
        let url = baseURL.appendingPathComponent("auth/login/")
        
        return performRequest(url: url, method: "POST", body: request)
    }
    
    func logout() -> AnyPublisher<MessageResponse, Error> {
        let url = baseURL.appendingPathComponent("auth/logout/")
        
        return performRequest(url: url, method: "POST", body: EmptyBody())
    }
    
    // MARK: - Check-ins
    
    func submitCheckIn(_ request: CheckInRequest) -> AnyPublisher<CheckInResponse, Error> {
        let url = baseURL.appendingPathComponent("checkins/")
        
        return performRequest(url: url, method: "POST", body: request)
    }
    
    func getCheckIns() -> AnyPublisher<[CheckInResponse], Error> {
        let url = baseURL.appendingPathComponent("checkins/")
        
        return performRequest(url: url, method: "GET")
    }
    
    // MARK: - Tips
    
    func getTips(category: String? = nil) -> AnyPublisher<TipsResponse, Error> {
        var url = baseURL.appendingPathComponent("tips/")
        
        if let category = category {
            url = url.appending(queryItems: [URLQueryItem(name: "category", value: category)])
        }
        
        return performRequest(url: url, method: "GET")
    }
    
    // MARK: - Quizzes
    
    func generateQuiz(domain: String) -> AnyPublisher<QuizResponse, Error> {
        let url = baseURL.appendingPathComponent("quizzes/")
        let request = QuizRequest(domain: domain)
        
        return performRequest(url: url, method: "POST", body: request)
    }
    
    // MARK: - Generic Request Handler
    
    private func performRequest<T: Codable, U: Codable>(
        url: URL,
        method: String,
        body: U? = nil
    ) -> AnyPublisher<T, Error> {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // For personal project: simplified auth without session cookies for login
        // Session cookies will be handled automatically by URLSession for authenticated requests
        
        if let body = body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                return Fail(error: error).eraseToAnyPublisher()
            }
        }
        
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                // Debug logging
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Status: \(httpResponse.statusCode)")
                }
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response: \(responseString)")
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    private func performRequest<T: Codable>(
        url: URL,
        method: String
    ) -> AnyPublisher<T, Error> {
        return performRequest(url: url, method: method, body: EmptyBody?.none)
    }
}

// MARK: - Request/Response Models

struct EmptyBody: Codable {}

struct LoginRequest: Codable {
    let username: String
    let password: String
}

struct LoginResponse: Codable {
    let user: UserResponse
    let message: String
}

struct UserResponse: Codable {
    let id: String  // Django returns UUID as string
    let email: String
    let username: String
    let firstName: String
    let lastName: String
    let avatar: String?
    let bio: String?
    let dateOfBirth: String?
    let timezone: String?
    let notificationPreferences: [String: AnyCodable]?
    let profile: UserProfileResponse?
    
    enum CodingKeys: String, CodingKey {
        case id, email, username, avatar, bio, timezone, profile
        case firstName = "first_name"
        case lastName = "last_name"
        case dateOfBirth = "date_of_birth"
        case notificationPreferences = "notification_preferences"
    }
}

struct UserProfileResponse: Codable {
    let progressPoints: Int
    let streakCount: Int
    let completedExercises: Int
    let completedQuizzes: Int
    let badges: [AnyCodable]
    let achievements: [AnyCodable]
    
    enum CodingKeys: String, CodingKey {
        case progressPoints = "progress_points"
        case streakCount = "streak_count"
        case completedExercises = "completed_exercises"
        case completedQuizzes = "completed_quizzes"
        case badges, achievements
    }
}

// Helper for decoding arbitrary JSON values
struct AnyCodable: Codable {
    let value: Any
    
    init<T>(_ value: T?) {
        self.value = value ?? ()
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let intValue = try? container.decode(Int.self) {
            value = intValue
        } else if let doubleValue = try? container.decode(Double.self) {
            value = doubleValue
        } else if let stringValue = try? container.decode(String.self) {
            value = stringValue
        } else if let boolValue = try? container.decode(Bool.self) {
            value = boolValue
        } else if let arrayValue = try? container.decode([AnyCodable].self) {
            value = arrayValue.map { $0.value }
        } else if let dictValue = try? container.decode([String: AnyCodable].self) {
            value = dictValue.mapValues { $0.value }
        } else {
            value = ()
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch value {
        case let intValue as Int:
            try container.encode(intValue)
        case let doubleValue as Double:
            try container.encode(doubleValue)
        case let stringValue as String:
            try container.encode(stringValue)
        case let boolValue as Bool:
            try container.encode(boolValue)
        case let arrayValue as [Any]:
            try container.encode(arrayValue.map { AnyCodable($0) })
        case let dictValue as [String: Any]:
            try container.encode(dictValue.mapValues { AnyCodable($0) })
        default:
            try container.encodeNil()
        }
    }
}

struct MessageResponse: Codable {
    let message: String
}

struct CheckInRequest: Codable {
    let moodLevel: Int
    let urgeLevel: Int
    let triggerContext: String
    let note: String
    
    enum CodingKeys: String, CodingKey {
        case moodLevel = "mood_level"
        case urgeLevel = "urge_level"
        case triggerContext = "trigger_context"
        case note
    }
}

struct CheckInResponse: Codable, Identifiable {
    let id: UUID
    let moodLevel: Int
    let urgeLevel: Int
    let triggerContext: String
    let note: String
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case moodLevel = "mood_level"
        case urgeLevel = "urge_level"
        case triggerContext = "trigger_context"
        case note
        case createdAt = "created_at"
    }
}

struct TipsResponse: Codable {
    let results: [TipItem]
    let count: Int
    let next: String?
    let previous: String?
}

struct TipItem: Codable, Identifiable {
    let id: UUID
    let title: String
    let content: String
    let category: String
    let isBookmarked: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, title, content, category
        case isBookmarked = "is_bookmarked"
    }
}

struct QuizRequest: Codable {
    let domain: String
}

struct QuizResponse: Codable {
    let id: UUID
    let domain: String
    let questions: [QuizQuestionResponse]
}

struct QuizQuestionResponse: Codable, Identifiable {
    let id: UUID
    let question: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String
    let tip: String
    
    enum CodingKeys: String, CodingKey {
        case id, question, options, explanation, tip
        case correctAnswer = "correct_answer"
    }
} 