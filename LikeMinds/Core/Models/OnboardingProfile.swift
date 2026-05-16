import Foundation

struct OnboardingProfile: Codable, Equatable, Sendable {
    var fullName: String = ""
    var username: String = ""
    var profilePhotoData: Data?
    var dateOfBirth: Date?
    var gender: String?
    var city: String = ""
    var occupationStatus: String = ""
    var bio: String = ""
    var personalityType: String = ""
    var socialComfort: SocialComfortLevel?
    var selectedInterestIDs: Set<String> = []
    var hobbiesNarrative: String = ""

    var isUsernameValid: Bool {
        let trimmed = username.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 3, trimmed.count <= 24 else { return false }
        let pattern = "^[a-zA-Z0-9_\\.]+$"
        return trimmed.range(of: pattern, options: .regularExpression) != nil
    }

    var isMinimumComplete: Bool {
        !fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && isUsernameValid
            && dateOfBirth != nil
            && !city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && socialComfort != nil
            && selectedInterestIDs.count >= 3
    }
}
