import SwiftUI

@MainActor
final class EditInterestsViewModel: ObservableObject {
    @Published var profile: LMUserProfile
    @Published var draftBio: String
    @Published var selectedInterests: Set<String>
    @Published var selectedVibes: Set<String>
    @Published var socialComfort: String

    private let allInterests = ["Trekking", "Reading", "Cricket", "Food", "Art", "Music", "Anime", "Running", "Startups", "Photography", "Café", "Yoga", "Coding", "Travel"]
    private let allVibes = ["Adventurer", "Thinker", "Connector", "Creator", "Balancer"]
    private let comfortOptions = ["Introvert", "Balanced", "Extrovert"]

    init(profile: LMUserProfile) {
        self.profile = profile
        draftBio = profile.bio
        selectedInterests = Set(profile.interests)
        selectedVibes = Set(profile.vibeTags)
        socialComfort = profile.socialComfort
    }

    var interestOptions: [String] { allInterests }
    var vibeOptions: [String] { allVibes }
    var comfortLevels: [String] { comfortOptions }

    func toggleInterest(_ item: String) {
        if selectedInterests.contains(item) { selectedInterests.remove(item) }
        else { selectedInterests.insert(item) }
    }

    func toggleVibe(_ item: String) {
        if selectedVibes.contains(item) { selectedVibes.remove(item) }
        else { selectedVibes.insert(item) }
    }

    func save() {
        profile.bio = draftBio
        profile.interests = Array(selectedInterests).sorted()
        profile.vibeTags = Array(selectedVibes).sorted()
        profile.socialComfort = socialComfort
    }
}
