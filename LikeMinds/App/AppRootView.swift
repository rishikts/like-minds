import SwiftUI

struct AppRootView: View {
    @StateObject private var authManager = AuthManager()
    @StateObject private var welcomeViewModel = WelcomeViewModel()
    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {
        Group {
            switch authManager.route {
            case .launching:
                launchingView
            case .welcome:
                WelcomeView(viewModel: welcomeViewModel)
            case .auth:
                AuthSheetView(viewModel: authViewModel)
            case .onboarding:
                OnboardingContainerView(
                    profile: authManager.session?.onboardingProfile ?? OnboardingProfile()
                )
            case .home:
                HomeView()
            }
        }
        .environmentObject(authManager)
        .animation(Theme.Layout.springSmooth, value: authManager.route)
        .onAppear {
            welcomeViewModel.onGetStarted = { authManager.presentAuth() }
            authManager.bootstrap()
        }
    }

    private var launchingView: some View {
        ZStack {
            GradientBackground()
            ProgressView()
                .tint(.white)
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    AppRootView()
}
