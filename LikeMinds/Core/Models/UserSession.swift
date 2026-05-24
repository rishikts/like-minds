import Foundation

struct UserSession: Codable, Equatable, Sendable {
    var user: AuthUser
    var accessToken: String?
    var refreshToken: String?
    var hasCompletedOnboarding: Bool
    var onboardingProfile: OnboardingProfile?
    var createdAt: Date
    var lastActiveAt: Date

    init(
        user: AuthUser,
        accessToken: String? = nil,
        refreshToken: String? = nil,
        hasCompletedOnboarding: Bool = false,
        onboardingProfile: OnboardingProfile? = nil,
        createdAt: Date = .now,
        lastActiveAt: Date = .now
    ) {
        self.user = user
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.hasCompletedOnboarding = hasCompletedOnboarding
        self.onboardingProfile = onboardingProfile
        self.createdAt = createdAt
        self.lastActiveAt = lastActiveAt
    }
}
