import Foundation

enum AuthError: LocalizedError, Equatable {
    case cancelled
    case providerUnavailable(AuthProviderKind)
    case missingConfiguration(String)
    case invalidCredentials
    case networkUnavailable
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .cancelled:
            "Sign in was cancelled."
        case .providerUnavailable(let provider):
            "\(provider.displayName) sign in isn't available right now."
        case .missingConfiguration(let detail):
            detail
        case .invalidCredentials:
            "We couldn't verify your account. Please try again."
        case .networkUnavailable:
            "Check your connection and try again."
        case .unknown(let message):
            message
        }
    }
}
