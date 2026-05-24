import Foundation

struct AuthUser: Codable, Equatable, Sendable {
    let id: String
    var email: String?
    var firstName: String?
    var lastName: String?
    var phoneNumber: String?
    var displayName: String?
    var photoURL: String?
    let provider: AuthProviderKind
    var isGuest: Bool { provider == .guest }

    var fullName: String {
        let parts = [firstName, lastName]
            .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        if !parts.isEmpty { return parts.joined(separator: " ") }
        return displayName ?? ""
    }

    init(
        id: String,
        email: String? = nil,
        firstName: String? = nil,
        lastName: String? = nil,
        phoneNumber: String? = nil,
        displayName: String? = nil,
        photoURL: String? = nil,
        provider: AuthProviderKind
    ) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.displayName = displayName
        self.photoURL = photoURL
        self.provider = provider
    }
}
