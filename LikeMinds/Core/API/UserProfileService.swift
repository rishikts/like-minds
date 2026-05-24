import Foundation

protocol UserProfileServing: Sendable {
  func syncProfile(authUser: AuthUser, profile: OnboardingProfile, isOnboarded: Bool) async throws -> UserProfileDTO
  func fetchProfile(externalAuthId: String) async throws -> UserProfileDTO
}

final class UserProfileService: UserProfileServing {
  private let client: APIClient

  init(client: APIClient = .shared) {
    self.client = client
  }

  func syncProfile(
    authUser: AuthUser,
    profile: OnboardingProfile,
    isOnboarded: Bool
  ) async throws -> UserProfileDTO {
    guard APIConfig.syncAPIKey != nil else {
      throw APIError.missingSyncKey
    }
    let body = UserProfileMapper.syncRequest(
      authUser: authUser,
      profile: profile,
      isOnboarded: isOnboarded
    )
    return try await client.put(path: "users/profile/sync", body: body)
  }

  func fetchProfile(externalAuthId: String) async throws -> UserProfileDTO {
    guard APIConfig.syncAPIKey != nil else {
      throw APIError.missingSyncKey
    }
    return try await client.get(path: "users/profile/\(externalAuthId)")
  }
}
