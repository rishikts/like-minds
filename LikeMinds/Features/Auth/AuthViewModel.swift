import SwiftUI

@MainActor
final class AuthViewModel: ObservableObject {
    @Published private(set) var activeProvider: AuthProviderKind?

    private weak var authManager: AuthManager?

    func bind(authManager: AuthManager) {
        self.authManager = authManager
    }

    var isLoading: Bool { authManager?.isAuthenticating == true }
    var errorMessage: String? { authManager?.authErrorMessage }

    func signIn(with provider: AuthProviderKind) {
        guard activeProvider == nil else { return }
        activeProvider = provider
        Task {
            await authManager?.signIn(with: provider)
            activeProvider = nil
        }
    }

    func dismiss() {
        authManager?.dismissAuth()
    }
}
