import Foundation

struct LMUserProfile: Hashable {
    var name: String
    var username: String
    var bio: String
    var city: String
    var interests: [String]
    var vibeTags: [String]
    var socialComfort: String
    var meetupsAttended: Int
    var meetupsHosted: Int
    var badges: [String]
    var favoriteCommunities: [String]
    var avatarSymbol: String
}
