import Foundation

protocol AuthenticationServiceProtocol: Sendable {
    func signIn(with provider: AuthProviderKind) async throws -> AuthUser
}

struct AuthenticationService: AuthenticationServiceProtocol {
    private let apple: AuthSigning
    private let google: AuthSigning
    private let guest: AuthSigning

    init(
        apple: AuthSigning = AppleSignInService(),
        google: AuthSigning = GoogleSignInService(),
        guest: AuthSigning = GuestSignInService()
    ) {
        self.apple = apple
        self.google = google
        self.guest = guest
    }

    func signIn(with provider: AuthProviderKind) async throws -> AuthUser {
        switch provider {
        case .apple: try await apple.signIn()
        case .google: try await google.signIn()
        case .guest: try await guest.signIn()
        }
    }
}
