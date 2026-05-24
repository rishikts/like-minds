import Foundation

final class GuestSignInService: AuthSigning, Sendable {
    let provider: AuthProviderKind = .guest

    func signIn() async throws -> AuthUser {
        AuthUser(
            id: "guest-\(UUID().uuidString)",
            email: nil,
            displayName: "Explorer",
            photoURL: nil,
            provider: .guest
        )
    }
}
