import Foundation

struct LMFeedActivity: Identifiable, Hashable {
    let id: String
    let userName: String
    let action: String
    let communityName: String
    let timeAgo: String
    let avatarSymbol: String
}

struct LMFeedRecommendation: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let cta: String
    let iconName: String
}
