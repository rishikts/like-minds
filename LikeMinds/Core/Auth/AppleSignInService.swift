import AuthenticationServices
import CryptoKit
import Foundation
import UIKit

final class AppleSignInService: NSObject, AuthSigning, @unchecked Sendable {
    let provider: AuthProviderKind = .apple

    private var continuation: CheckedContinuation<AuthUser, Error>?
    private var currentNonce: String?

    func signIn() async throws -> AuthUser {
        try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            let nonce = Self.randomNonceString()
            currentNonce = nonce

            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = Self.sha256(nonce)

            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    }

    private static func randomNonceString(length: Int = 32) -> String {
        let charset = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remaining = length
        while remaining > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in UInt8.random(in: 0...255) }
            randoms.forEach { random in
                guard remaining > 0 else { return }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remaining -= 1
                }
            }
        }
        return result
    }

    private static func sha256(_ input: String) -> String {
        let data = Data(input.utf8)
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}

extension AppleSignInService: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            continuation?.resume(throwing: AuthError.invalidCredentials)
            continuation = nil
            return
        }

        let givenName = credential.fullName?.givenName
        let familyName = credential.fullName?.familyName
        let fullName = [givenName, familyName]
            .compactMap { $0 }
            .joined(separator: " ")

        let user = AuthUser(
            id: credential.user,
            email: credential.email,
            firstName: givenName,
            lastName: familyName,
            displayName: fullName.isEmpty ? nil : fullName,
            photoURL: nil,
            provider: .apple
        )
        continuation?.resume(returning: user)
        continuation = nil
    }

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        let authError: AuthError
        if let asError = error as? ASAuthorizationError, asError.code == .canceled {
            authError = .cancelled
        } else {
            authError = .unknown(error.localizedDescription)
        }
        continuation?.resume(throwing: authError)
        continuation = nil
    }
}

extension AppleSignInService: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let scene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }),
              let window = scene.windows.first(where: \.isKeyWindow)
        else {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap(\.windows)
                .first ?? ASPresentationAnchor()
        }
        return window
    }
}
