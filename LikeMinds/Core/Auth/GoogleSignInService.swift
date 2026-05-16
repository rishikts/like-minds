import Foundation
import UIKit

#if canImport(GoogleSignIn)
import GoogleSignIn
#endif

final class GoogleSignInService: AuthSigning, @unchecked Sendable {
    let provider: AuthProviderKind = .google

    func signIn() async throws -> AuthUser {
        #if canImport(GoogleSignIn)
        return try await signInWithSDK()
        #else
        throw AuthError.missingConfiguration(
            "Google Sign-In SDK is not linked. Add the GoogleSignIn-iOS package in Xcode."
        )
        #endif
    }

    #if canImport(GoogleSignIn)
    @MainActor
    private func signInWithSDK() async throws -> AuthUser {
        guard let presenting = Self.topViewController() else {
            throw AuthError.providerUnavailable(.google)
        }

        let result: GIDSignInResult
        do {
            result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presenting)
        } catch {
            if (error as NSError).code == GIDSignInError.canceled.rawValue {
                throw AuthError.cancelled
            }
            throw AuthError.unknown(error.localizedDescription)
        }

        let profile = result.user.profile
        return AuthUser(
            id: result.user.userID ?? UUID().uuidString,
            email: profile?.email,
            displayName: profile?.name,
            photoURL: profile?.imageURL(withDimension: 200)?.absoluteString,
            provider: .google
        )
    }

    @MainActor
    private static func topViewController(
        base: UIViewController? = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)?
            .rootViewController
    ) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
    #endif
}
