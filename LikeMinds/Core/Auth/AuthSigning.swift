import Foundation

protocol AuthSigning: Sendable {
    var provider: AuthProviderKind { get }
    func signIn() async throws -> AuthUser
}
