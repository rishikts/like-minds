import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var authManager: AuthManager

    var body: some View {
        ZStack {
            GradientBackground()

            VStack(spacing: 24) {
                Spacer()

                Image(systemName: "sparkles")
                    .font(.system(size: 48))
                    .foregroundStyle(Theme.Colors.heroGradient)

                Text("You're in!")
                    .font(Theme.Typography.display(34))
                    .foregroundStyle(.white)

                if let name = authManager.session?.onboardingProfile?.fullName, !name.isEmpty {
                    Text("Welcome, \(name.split(separator: " ").first.map(String.init) ?? name)")
                        .font(Theme.Typography.body(17))
                        .foregroundStyle(Theme.Colors.textSecondary)
                }

                Text("Your profile is ready for matching, events, and AI-powered recommendations.")
                    .font(Theme.Typography.body(15))
                    .foregroundStyle(Theme.Colors.textTertiary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Spacer()

                SecondaryButton(title: "Sign Out") {
                    authManager.signOut()
                }
                .padding(.horizontal, Theme.Layout.horizontalPadding)
                .padding(.bottom, 32)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthManager())
}
