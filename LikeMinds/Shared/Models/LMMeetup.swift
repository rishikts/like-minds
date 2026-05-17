import Foundation

struct LMMeetup: Identifiable, Hashable {
    let id: String
    let title: String
    let communityName: String
    let location: String
    let date: Date
    let attendeeCount: Int
    let maxAttendees: Int
    let vibeTags: [String]
    let imageSymbol: String
    let isTrending: Bool
}
