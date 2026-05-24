import SwiftUI

struct AuthSheetView: View {
    @ObservedObject var viewModel: AuthViewModel
    @EnvironmentObject private var authManager: AuthManager

    @State private var appear = false

    var body: some View {
        ZStack {
            GradientBackground()
            FloatingOrbs(orbs: FloatingOrbs.welcomePreset)
                .opacity(0.65)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    header
                    providers
                    guestSection
                    legal
                }
                .padding(.horizontal, Theme.Layout.horizontalPadding)
                .padding(.top, 12)
                .padding(.bottom, 32)
            }
        }
        .preferredColorScheme(.dark)
        .overlay(alignment: .topLeading) {
            closeButton
        }
        .onAppear {
            viewModel.bind(authManager: authManager)
            withAnimation(Theme.Layout.springSmooth.delay(0.05)) {
                appear = true
            }
        }
    }

    private var closeButton: some View {
        Button {
            viewModel.dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(Theme.Colors.textSecondary)
                .frame(width: 40, height: 40)
                .background(Circle().fill(Theme.Colors.glassFill))
        }
        .padding(.leading, 20)
        .padding(.top, 8)
        .accessibilityLabel("Close")
    }

    private var header: some View {
        VStack(spacing: 14) {
            Text("Join Like Minds")
                .font(Theme.Typography.display(32))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, Theme.Colors.accentViolet.opacity(0.9)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Text("Sign in to discover people who share your passions — safely, beautifully, and on your terms.")
                .font(Theme.Typography.body(16))
                .foregroundStyle(Theme.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .padding(.top, 44)
        .opacity(appear ? 1 : 0)
        .offset(y: appear ? 0 : 16)
    }

    private var providers: some View {
        VStack(spacing: 12) {
            if let error = viewModel.errorMessage {
                ErrorBanner(message: error)
            }

            AuthProviderButton(
                title: "Continue with Apple",
                symbolName: "apple.logo",
                style: .filled,
                isLoading: viewModel.activeProvider == .apple
            ) {
                viewModel.signIn(with: .apple)
            }

            AuthProviderButton(
                title: "Continue with Google",
                symbolName: "g.circle.fill",
                isLoading: viewModel.activeProvider == .google
            ) {
                viewModel.signIn(with: .google)
            }
        }
        .opacity(appear ? 1 : 0)
        .offset(y: appear ? 0 : 20)
    }

    private var guestSection: some View {
        VStack(spacing: 16) {
            HStack {
                Rectangle().fill(Theme.Colors.glassStroke.opacity(0.35)).frame(height: 1)
                Text("or")
                    .font(Theme.Typography.caption(13))
                    .foregroundStyle(Theme.Colors.textTertiary)
                Rectangle().fill(Theme.Colors.glassStroke.opacity(0.35)).frame(height: 1)
            }

            AuthProviderButton(
                title: "Continue as Guest",
                symbolName: "person.crop.circle.badge.questionmark",
                style: .subtle,
                isLoading: viewModel.activeProvider == .guest
            ) {
                viewModel.signIn(with: .guest)
            }

            Text("Explore with limited features — you can link an account anytime.")
                .font(Theme.Typography.caption(12))
                .foregroundStyle(Theme.Colors.textTertiary)
                .multilineTextAlignment(.center)
        }
        .opacity(appear ? 1 : 0)
    }

    private var legal: some View {
        Text("By continuing, you agree to our Terms and Privacy Policy.")
            .font(Theme.Typography.caption(11))
            .foregroundStyle(Theme.Colors.textTertiary)
            .multilineTextAlignment(.center)
            .padding(.top, 8)
    }
}

#Preview {
    AuthSheetView(viewModel: AuthViewModel())
        .environmentObject(AuthManager())
}
