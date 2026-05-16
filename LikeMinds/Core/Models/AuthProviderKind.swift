import Foundation

enum AuthProviderKind: String, Codable, CaseIterable, Sendable {
    case apple
    case google
    case guest

    var displayName: String {
        switch self {
        case .apple: "Apple"
        case .google: "Google"
        case .guest: "Guest"
        }
    }
}
