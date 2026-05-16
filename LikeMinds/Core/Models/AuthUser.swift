import Foundation

struct AuthUser: Codable, Equatable, Sendable {
    let id: String
    var email: String?
    var displayName: String?
    var photoURL: String?
    let provider: AuthProviderKind
    var isGuest: Bool { provider == .guest }
}
