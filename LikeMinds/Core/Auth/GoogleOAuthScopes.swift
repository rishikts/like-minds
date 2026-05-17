import Foundation

enum GoogleOAuthScopes {
    /// Standard OpenID profile + email (included in Google Sign-In by default).
    static let profile = "profile"
    static let email = "email"

    /// Optional — user must grant access; phone may still be unavailable on some accounts.
    static let phoneNumbers = "https://www.googleapis.com/auth/user.phonenumbers.read"

    static var signInAdditionalScopes: [String] {
        [phoneNumbers]
    }
}
