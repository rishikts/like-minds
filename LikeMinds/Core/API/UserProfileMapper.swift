import Foundation

enum UserProfileMapper {
  static func syncRequest(
    authUser: AuthUser,
    profile: OnboardingProfile,
    isOnboarded: Bool
  ) -> UserProfileSyncRequest {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withFullDate]

    return UserProfileSyncRequest(
      externalAuthId: authUser.id,
      email: authUser.email,
      authProvider: authUser.provider.rawValue,
      fullName: profile.fullName.nilIfBlank,
      phone: profile.phoneNumber ?? authUser.phoneNumber,
      username: profile.username.nilIfBlank,
      bio: profile.bio.nilIfBlank,
      dateOfBirth: profile.dateOfBirth.map { formatter.string(from: $0) },
      gender: profile.gender,
      city: profile.city.nilIfBlank,
      occupationStatus: profile.occupationStatus.nilIfBlank,
      personalityTypes: Array(profile.personalityTypes).sorted(),
      socialComfort: profile.socialComfort?.rawValue,
      selectedInterestIds: Array(profile.selectedInterestIDs).sorted(),
      hobbiesNarrative: profile.hobbiesNarrative.nilIfBlank,
      isOnboarded: isOnboarded
    )
  }

  static func lmProfile(
    from dto: UserProfileDTO,
  ) -> LMUserProfile {
    let interests = dto.selectedInterestIds.compactMap { InterestCatalog.title(for: $0) }
    let vibes = dto.personalityTypes
    let comfortTitle = dto.socialComfort.flatMap { SocialComfortLevel(rawValue: $0)?.title }
      ?? dto.socialComfort?.capitalized
      ?? "Balanced"

    return LMUserProfile(
      name: dto.fullName ?? dto.username ?? "You",
      username: dto.username ?? "member",
      bio: dto.bio ?? "",
      city: dto.city ?? "",
      interests: interests.isEmpty ? ["Exploring"] : interests,
      vibeTags: vibes,
      socialComfort: comfortTitle ?? "Balanced",
      meetupsAttended: dto.meetupsAttended,
      meetupsHosted: dto.meetupsHosted,
      badges: dto.badges,
      favoriteCommunities: dto.favoriteCommunities,
      avatarSymbol: avatarSymbol(for: dto)
    )
  }

  static func lmProfile(
    session: UserSession,
    dto: UserProfileDTO? = nil
  ) -> LMUserProfile {
    if let dto {
      return lmProfile(from: dto)
    }
    guard let onboarding = session.onboardingProfile else {
      return LMUserProfile(
        name: session.user.fullName.nilIfBlank ?? "You",
        username: "member",
        bio: "",
        city: "",
        interests: [],
        vibeTags: [],
        socialComfort: "Balanced",
        meetupsAttended: 0,
        meetupsHosted: 0,
        badges: [],
        favoriteCommunities: [],
        avatarSymbol: "person.crop.circle.fill"
      )
    }
    return lmProfile(
      from: UserProfileDTO.placeholder(from: onboarding, authUser: session.user)
    )
  }

  private static func avatarSymbol(for dto: UserProfileDTO) -> String {
    if let first = dto.personalityTypes.first?.lowercased() {
      switch first {
      case "adventurer": return "figure.hiking"
      case "thinker": return "brain.head.profile"
      case "connector": return "person.2.fill"
      case "creator": return "paintbrush.fill"
      case "balancer": return "scalemass.fill"
      default: break
      }
    }
    return "person.crop.circle.fill"
  }
}

private extension String {
  var nilIfBlank: String? {
    let t = trimmingCharacters(in: .whitespacesAndNewlines)
    return t.isEmpty ? nil : t
  }
}

private extension UserProfileDTO {
  static func placeholder(from profile: OnboardingProfile, authUser: AuthUser) -> UserProfileDTO {
    UserProfileDTO(
      id: authUser.id,
      supabaseId: nil,
      externalAuthId: authUser.id,
      email: authUser.email ?? "guest@likeminds.app",
      fullName: profile.fullName.nilIfBlank,
      username: profile.username.nilIfBlank,
      phone: profile.phoneNumber,
      bio: profile.bio.nilIfBlank,
      dateOfBirth: nil,
      gender: profile.gender,
      city: profile.city.nilIfBlank,
      occupationStatus: profile.occupationStatus.nilIfBlank,
      personalityTypes: Array(profile.personalityTypes),
      socialComfort: profile.socialComfort?.rawValue,
      selectedInterestIds: Array(profile.selectedInterestIDs),
      hobbiesNarrative: profile.hobbiesNarrative.nilIfBlank,
      authProvider: authUser.provider.rawValue,
      profileImageUrl: nil,
      meetupsAttended: 0,
      meetupsHosted: 0,
      badges: [],
      favoriteCommunities: [],
      isOnboarded: profile.isMinimumComplete
    )
  }
}

extension InterestCatalog {
  static func title(for id: String) -> String? {
    for category in categories {
      if let item = category.items.first(where: { $0.id == id }) {
        return item.title
      }
    }
    return id.capitalized
  }
}
