import Foundation

enum SocialComfortLevel: String, Codable, CaseIterable, Identifiable, Sendable {
    case introvert
    case balanced
    case extrovert

    var id: String { rawValue }

    var title: String {
        switch self {
        case .introvert: "Introvert"
        case .balanced: "Balanced"
        case .extrovert: "Extrovert"
        }
    }

    var subtitle: String {
        switch self {
        case .introvert: "I recharge in quiet, intimate settings"
        case .balanced: "I enjoy both cozy hangs and lively groups"
        case .extrovert: "I thrive meeting new people often"
        }
    }

    var symbolName: String {
        switch self {
        case .introvert: "moon.stars.fill"
        case .balanced: "scalemass.fill"
        case .extrovert: "sparkles"
        }
    }
}
