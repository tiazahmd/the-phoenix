import Foundation
import Combine

class APIClient {
    static let shared = APIClient()
    
    private let baseURL = URL(string: "http://localhost:8000/api/v1")!
    private let session = URLSession.shared
    
    private init() {}
    
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
        
        // Add CSRF token and session handling for Django
        if let cookies = HTTPCookieStorage.shared.cookies(for: url) {
            let cookieHeader = HTTPCookie.requestHeaderFields(with: cookies)
            for (key, value) in cookieHeader {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let body = body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                return Fail(error: error).eraseToAnyPublisher()
            }
        }
        
        // Debug: Print the request details
        print("🌐 Making request to: \(request.url?.absoluteString ?? "unknown")")
        print("🔧 Method: \(request.httpMethod ?? "unknown")")
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print("📤 Request Body: \(bodyString)")
        }
        
        return session.dataTaskPublisher(for: request)
            .map { data, response in
                // Debug: Print the raw response
                if let httpResponse = response as? HTTPURLResponse {
                    print("📥 HTTP Status: \(httpResponse.statusCode)")
                    print("📥 Response Headers: \(httpResponse.allHeaderFields)")
                }
                if let responseString = String(data: data, encoding: .utf8) {
                    print("📥 Raw Response: \(responseString)")
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .catch { error in
                print("Decoding Error: \(error)")
                if let decodingError = error as? DecodingError {
                    print("Decoding Error Details: \(decodingError)")
                }
                return Fail<T, Error>(error: error)
            }
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