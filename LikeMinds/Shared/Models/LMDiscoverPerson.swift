import Foundation

struct LMDiscoverPerson: Identifiable, Hashable {
    let id: String
    let name: String
    let age: Int
    let city: String
    let bio: String
    let interests: [String]
    let vibeTags: [String]
    let mutualCount: Int
    let matchScore: Int
    let avatarSymbol: String
}
