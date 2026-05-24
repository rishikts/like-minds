import Foundation

/// Request/response shape for PUT /users/profile/sync
struct UserProfileSyncRequest: Encodable {
  let externalAuthId: String
  let email: String?
  let authProvider: String?
  let fullName: String?
  let phone: String?
  let username: String?
  let bio: String?
  let dateOfBirth: String?
  let gender: String?
  let city: String?
  let occupationStatus: String?
  let personalityTypes: [String]
  let socialComfort: String?
  let selectedInterestIds: [String]
  let hobbiesNarrative: String?
  let isOnboarded: Bool
}

struct UserProfileDTO: Codable {
  let id: String
  let supabaseId: String?
  let externalAuthId: String?
  let email: String
  let fullName: String?
  let username: String?
  let phone: String?
  let bio: String?
  let dateOfBirth: String?
  let gender: String?
  let city: String?
  let occupationStatus: String?
  let personalityTypes: [String]
  let socialComfort: String?
  let selectedInterestIds: [String]
  let hobbiesNarrative: String?
  let authProvider: String?
  let profileImageUrl: String?
  let meetupsAttended: Int
  let meetupsHosted: Int
  let badges: [String]
  let favoriteCommunities: [String]
  let isOnboarded: Bool
}
