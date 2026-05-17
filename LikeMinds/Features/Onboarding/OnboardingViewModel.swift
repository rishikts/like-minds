import SwiftUI

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var profile: OnboardingProfile
    @Published private(set) var currentStep: OnboardingStep = .fullName
    @Published private(set) var direction: NavigationDirection = .forward

    enum NavigationDirection { case forward, backward }

    private weak var authManager: AuthManager?

    init(profile: OnboardingProfile = OnboardingProfile()) {
        self.profile = profile
    }

    func bind(authManager: AuthManager) {
        self.authManager = authManager
        if let existing = authManager.session?.onboardingProfile {
            profile = existing
        }
    }

    var canContinue: Bool {
        switch currentStep {
        case .fullName:
            !profile.fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .username:
            profile.isUsernameValid
        case .profilePhoto:
            true
        case .dateOfBirth:
            profile.dateOfBirth != nil && isAgeValid
        case .gender, .bio, .hobbies:
            true
        case .city:
            !profile.city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .occupation:
            !profile.occupationStatus.isEmpty
        case .personality:
            !profile.personalityTypes.isEmpty
        case .socialComfort:
            profile.socialComfort != nil
        case .interests:
            profile.selectedInterestIDs.count >= 3
        }
    }

    private var isAgeValid: Bool {
        guard let dob = profile.dateOfBirth else { return false }
        let years = Calendar.current.dateComponents([.year], from: dob, to: .now).year ?? 0
        return years >= 16 && years <= 100
    }

    func goForward() {
        guard canContinue else { return }
        authManager?.updateOnboardingProfile(profile)
        guard let next = OnboardingStep(rawValue: currentStep.rawValue + 1) else {
            finish()
            return
        }
        direction = .forward
        withAnimation(Theme.Layout.springSmooth) {
            currentStep = next
        }
    }

    func skip() {
        guard currentStep.isSkippable else { return }
        goForward()
    }

    func goBack() {
        guard let previous = OnboardingStep(rawValue: currentStep.rawValue - 1) else { return }
        direction = .backward
        withAnimation(Theme.Layout.springSmooth) {
            currentStep = previous
        }
    }

    func toggleInterest(_ id: String) {
        if profile.selectedInterestIDs.contains(id) {
            profile.selectedInterestIDs.remove(id)
        } else {
            profile.selectedInterestIDs.insert(id)
        }
    }

    func togglePersonalityVibe(_ title: String) {
        if profile.personalityTypes.contains(title) {
            profile.personalityTypes.remove(title)
        } else {
            profile.personalityTypes.insert(title)
        }
    }

    func finish() {
        authManager?.completeOnboarding(with: profile)
    }
}
