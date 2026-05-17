import Foundation

struct LMCommunity: Identifiable, Hashable {
    let id: String
    let name: String
    let category: String
    let description: String
    let memberCount: Int
    let vibeTags: [String]
    let iconName: String
    let gradientColors: [String]
    let upcomingMeetupCount: Int
}
