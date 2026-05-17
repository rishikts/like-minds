import Foundation

struct OnboardingProfile: Codable, Equatable, Sendable {
    var fullName: String = ""
    var phoneNumber: String?
    var username: String = ""
    var profilePhotoData: Data?
    var dateOfBirth: Date?
    var gender: String?
    var city: String = ""
    var occupationStatus: String = ""
    var bio: String = ""
    var personalityTypes: Set<String> = []
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
            && !personalityTypes.isEmpty
            && selectedInterestIDs.count >= 3
    }

    init(
        fullName: String = "",
        phoneNumber: String? = nil,
        username: String = "",
        profilePhotoData: Data? = nil,
        dateOfBirth: Date? = nil,
        gender: String? = nil,
        city: String = "",
        occupationStatus: String = "",
        bio: String = "",
        personalityTypes: Set<String> = [],
        socialComfort: SocialComfortLevel? = nil,
        selectedInterestIDs: Set<String> = [],
        hobbiesNarrative: String = ""
    ) {
        self.fullName = fullName
        self.phoneNumber = phoneNumber
        self.username = username
        self.profilePhotoData = profilePhotoData
        self.dateOfBirth = dateOfBirth
        self.gender = gender
        self.city = city
        self.occupationStatus = occupationStatus
        self.bio = bio
        self.personalityTypes = personalityTypes
        self.socialComfort = socialComfort
        self.selectedInterestIDs = selectedInterestIDs
        self.hobbiesNarrative = hobbiesNarrative
    }

    private enum CodingKeys: String, CodingKey {
        case fullName, phoneNumber, username, profilePhotoData, dateOfBirth, gender, city
        case occupationStatus, bio, personalityTypes, personalityType, socialComfort
        case selectedInterestIDs, hobbiesNarrative
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fullName = try container.decodeIfPresent(String.self, forKey: .fullName) ?? ""
        phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        username = try container.decodeIfPresent(String.self, forKey: .username) ?? ""
        profilePhotoData = try container.decodeIfPresent(Data.self, forKey: .profilePhotoData)
        dateOfBirth = try container.decodeIfPresent(Date.self, forKey: .dateOfBirth)
        gender = try container.decodeIfPresent(String.self, forKey: .gender)
        city = try container.decodeIfPresent(String.self, forKey: .city) ?? ""
        occupationStatus = try container.decodeIfPresent(String.self, forKey: .occupationStatus) ?? ""
        bio = try container.decodeIfPresent(String.self, forKey: .bio) ?? ""
        socialComfort = try container.decodeIfPresent(SocialComfortLevel.self, forKey: .socialComfort)
        selectedInterestIDs = try container.decodeIfPresent(Set<String>.self, forKey: .selectedInterestIDs) ?? []
        hobbiesNarrative = try container.decodeIfPresent(String.self, forKey: .hobbiesNarrative) ?? ""

        if let types = try container.decodeIfPresent(Set<String>.self, forKey: .personalityTypes) {
            personalityTypes = types
        } else if let legacy = try container.decodeIfPresent(String.self, forKey: .personalityType), !legacy.isEmpty {
            personalityTypes = [legacy]
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fullName, forKey: .fullName)
        try container.encodeIfPresent(phoneNumber, forKey: .phoneNumber)
        try container.encode(username, forKey: .username)
        try container.encodeIfPresent(profilePhotoData, forKey: .profilePhotoData)
        try container.encodeIfPresent(dateOfBirth, forKey: .dateOfBirth)
        try container.encodeIfPresent(gender, forKey: .gender)
        try container.encode(city, forKey: .city)
        try container.encode(occupationStatus, forKey: .occupationStatus)
        try container.encode(bio, forKey: .bio)
        try container.encode(personalityTypes, forKey: .personalityTypes)
        try container.encodeIfPresent(socialComfort, forKey: .socialComfort)
        try container.encode(selectedInterestIDs, forKey: .selectedInterestIDs)
        try container.encode(hobbiesNarrative, forKey: .hobbiesNarrative)
    }
}
