import Foundation
import SwiftUI

enum AppRoute: Equatable {
    case launching
    case welcome
    case auth
    case onboarding
    case home
}

@MainActor
final class AuthManager: ObservableObject {
    @Published private(set) var session: UserSession?
    @Published private(set) var route: AppRoute = .launching
    @Published var authErrorMessage: String?
    @Published private(set) var isAuthenticating = false

    private let authenticationService: AuthenticationServiceProtocol
    private let sessionStore: SessionStoring

    init(
        authenticationService: AuthenticationServiceProtocol = AuthenticationService(),
        sessionStore: SessionStoring = SessionStore()
    ) {
        self.authenticationService = authenticationService
        self.sessionStore = sessionStore
    }

    func bootstrap() {
        if let stored = sessionStore.load() {
            session = stored
            route = stored.hasCompletedOnboarding ? .home : .onboarding
        } else {
            route = .welcome
        }
    }

    func presentAuth() {
        authErrorMessage = nil
        route = .auth
    }

    func dismissAuth() {
        route = session == nil ? .welcome : (session?.hasCompletedOnboarding == true ? .home : .onboarding)
    }

    func signIn(with provider: AuthProviderKind) async {
        guard !isAuthenticating else { return }
        isAuthenticating = true
        authErrorMessage = nil
        defer { isAuthenticating = false }

        do {
            let user = try await authenticationService.signIn(with: provider)
            var profile = OnboardingProfile()
            if let name = user.displayName, !name.isEmpty {
                profile.fullName = name
            }
            let newSession = UserSession(
                user: user,
                accessToken: provider == .guest ? nil : "local-\(UUID().uuidString)",
                hasCompletedOnboarding: false,
                onboardingProfile: profile
            )
            try sessionStore.save(newSession)
            session = newSession
            route = .onboarding
        } catch let error as AuthError where error == .cancelled {
            return
        } catch {
            authErrorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
    }

    func updateOnboardingProfile(_ profile: OnboardingProfile) {
        guard var current = session else { return }
        current.onboardingProfile = profile
        current.lastActiveAt = .now
        session = current
        try? sessionStore.save(current)
    }

    func completeOnboarding(with profile: OnboardingProfile) {
        guard var current = session else { return }
        current.onboardingProfile = profile
        current.hasCompletedOnboarding = true
        current.lastActiveAt = .now
        session = current
        try? sessionStore.save(current)
        route = .home
    }

    func signOut() {
        try? sessionStore.clear()
        session = nil
        authErrorMessage = nil
        route = .welcome
    }
}
