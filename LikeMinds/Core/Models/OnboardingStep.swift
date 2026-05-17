import Foundation

enum OnboardingStep: Int, CaseIterable, Identifiable, Sendable {
    case fullName = 0
    case username
    case profilePhoto
    case dateOfBirth
    case gender
    case city
    case occupation
    case bio
    case personality
    case socialComfort
    case interests
    case hobbies

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .fullName: "What's your name?"
        case .username: "Pick a username"
        case .profilePhoto: "Add a profile photo"
        case .dateOfBirth: "When's your birthday?"
        case .gender: "How do you identify?"
        case .city: "Where are you based?"
        case .occupation: "What keeps you busy?"
        case .bio: "Tell your story"
        case .personality: "Your vibe"
        case .socialComfort: "Social energy"
        case .interests: "What lights you up?"
        case .hobbies: "Anything else?"
        }
    }

    var subtitle: String {
        switch self {
        case .fullName: "Real connections start with the real you."
        case .username: "This is how friends will find you."
        case .profilePhoto: "A friendly face goes a long way."
        case .dateOfBirth: "We use this to keep communities age-appropriate."
        case .gender: "Optional — share only if you'd like."
        case .city: "We'll surface local people and events."
        case .occupation: "Student, builder, explorer — all welcome."
        case .bio: "A few lines about what matters to you."
        case .personality: "Pick all vibes that feel like you — no limit."
        case .socialComfort: "No wrong answers — just be honest."
        case .interests: "Choose at least 3 — we'll personalize everything."
        case .hobbies: "The details that make you, you."
        }
    }

    var isSkippable: Bool {
        switch self {
        case .gender, .profilePhoto, .bio, .hobbies: true
        default: false
        }
    }

    var progressIndex: Int { rawValue + 1 }
    static var totalCount: Int { allCases.count }
}
