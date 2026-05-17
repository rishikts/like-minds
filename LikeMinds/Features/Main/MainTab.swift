import Foundation

enum MainTab: String, CaseIterable, Identifiable {
    case home
    case communities
    case meetups
    case discover
    case profile

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home: "Home"
        case .communities: "Circles"
        case .meetups: "Meetups"
        case .discover: "Discover"
        case .profile: "You"
        }
    }

    var icon: String {
        switch self {
        case .home: "house.fill"
        case .communities: "person.3.fill"
        case .meetups: "calendar"
        case .discover: "sparkles"
        case .profile: "person.crop.circle.fill"
        }
    }
}
