import Foundation
import SwiftUI

#if canImport(GoogleSignIn)
import GoogleSignIn
#endif

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
    private let welcomeEmailNotifier: WelcomeEmailNotifying
    private let userProfileService: UserProfileServing

    init(
        authenticationService: AuthenticationServiceProtocol = AuthenticationService(),
        sessionStore: SessionStoring = SessionStore(),
        welcomeEmailNotifier: WelcomeEmailNotifying = WelcomeEmailNotifier(),
        userProfileService: UserProfileServing = UserProfileService()
    ) {
        self.authenticationService = authenticationService
        self.sessionStore = sessionStore
        self.welcomeEmailNotifier = welcomeEmailNotifier
        self.userProfileService = userProfileService
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
            applyUserToOnboardingProfile(user, profile: &profile)

            let newSession = UserSession(
                user: user,
                accessToken: provider == .guest ? nil : "local-\(UUID().uuidString)",
                hasCompletedOnboarding: false,
                onboardingProfile: profile
            )
            try sessionStore.save(newSession)
            session = newSession
            route = .onboarding

            if provider == .google {
                Task {
                    await welcomeEmailNotifier.sendSignInSuccessEmail(for: user)
                }
            }
        } catch let error as AuthError where error == .cancelled {
            return
        } catch {
            authErrorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
    }

    private func applyUserToOnboardingProfile(_ user: AuthUser, profile: inout OnboardingProfile) {
        if !user.fullName.isEmpty {
            profile.fullName = user.fullName
        } else if let displayName = user.displayName, !displayName.isEmpty {
            profile.fullName = displayName
        }
        if let phone = user.phoneNumber, !phone.isEmpty {
            profile.phoneNumber = phone
        }
    }

    func updateOnboardingProfile(_ profile: OnboardingProfile) {
        guard var current = session else { return }
        current.onboardingProfile = profile
        current.lastActiveAt = .now
        session = current
        try? sessionStore.save(current)
        Task { await syncProfileToBackend(profile: profile, isOnboarded: false) }
    }

    func completeOnboarding(with profile: OnboardingProfile) {
        guard var current = session else { return }
        current.onboardingProfile = profile
        current.hasCompletedOnboarding = true
        current.lastActiveAt = .now
        session = current
        try? sessionStore.save(current)
        route = .home
        Task { await syncProfileToBackend(profile: profile, isOnboarded: true) }
    }

    private func syncProfileToBackend(profile: OnboardingProfile, isOnboarded: Bool) async {
        guard let current = session else { return }
        do {
            _ = try await userProfileService.syncProfile(
                authUser: current.user,
                profile: profile,
                isOnboarded: isOnboarded
            )
        } catch {
            // Offline or backend not configured — local session remains source of truth.
            #if DEBUG
            print("[LikeMinds] Profile sync skipped/failed: \(error.localizedDescription)")
            #endif
        }
    }

    func signOut() {
        #if canImport(GoogleSignIn)
        GIDSignIn.sharedInstance.signOut()
        #endif
        try? sessionStore.clear()
        session = nil
        authErrorMessage = nil
        route = .welcome
    }
}
