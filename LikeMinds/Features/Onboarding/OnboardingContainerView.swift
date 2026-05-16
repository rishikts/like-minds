import SwiftUI

struct OnboardingContainerView: View {
    @StateObject private var viewModel: OnboardingViewModel
    @EnvironmentObject private var authManager: AuthManager

    init(profile: OnboardingProfile = OnboardingProfile()) {
        _viewModel = StateObject(wrappedValue: OnboardingViewModel(profile: profile))
    }

    var body: some View {
        ZStack {
            GradientBackground()
            FloatingOrbs(orbs: FloatingOrbs.welcomePreset)
                .opacity(0.5)

            VStack(spacing: 0) {
                topBar
                    .padding(.horizontal, Theme.Layout.horizontalPadding)
                    .padding(.top, 8)

                OnboardingProgressBar(
                    current: viewModel.currentStep.progressIndex,
                    total: OnboardingStep.totalCount
                )
                .padding(.horizontal, Theme.Layout.horizontalPadding)
                .padding(.top, 16)
                .padding(.bottom, 20)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        OnboardingStepHeader(
                            title: viewModel.currentStep.title,
                            subtitle: viewModel.currentStep.subtitle
                        )

                        OnboardingStepContent(viewModel: viewModel, step: viewModel.currentStep)
                            .id(viewModel.currentStep)
                            .transition(stepTransition)
                    }
                    .padding(.horizontal, Theme.Layout.horizontalPadding)
                    .padding(.bottom, 120)
                }

                bottomBar
                    .padding(.horizontal, Theme.Layout.horizontalPadding)
                    .padding(.bottom, 24)
                    .background {
                        LinearGradient(
                            colors: [.clear, Theme.Colors.canvasBottom.opacity(0.95)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .ignoresSafeArea()
                    }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            viewModel.bind(authManager: authManager)
        }
    }

    private var topBar: some View {
        HStack {
            if viewModel.currentStep != .fullName {
                Button {
                    viewModel.goBack()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Theme.Colors.textSecondary)
                        .frame(width: 40, height: 40)
                        .background(Circle().fill(Theme.Colors.glassFill))
                }
            } else {
                Color.clear.frame(width: 40, height: 40)
            }

            Spacer()

            if viewModel.currentStep.isSkippable {
                Button("Skip") { viewModel.skip() }
                    .font(Theme.Typography.caption(14))
                    .foregroundStyle(Theme.Colors.textTertiary)
            }
        }
    }

    private var bottomBar: some View {
        let isLast = viewModel.currentStep == .hobbies
        return PrimaryButton(
            title: isLast ? "Enter Like Minds" : "Continue",
            isEnabled: viewModel.canContinue
        ) {
            if isLast {
                viewModel.finish()
            } else {
                viewModel.goForward()
            }
        }
    }

    private var stepTransition: AnyTransition {
        switch viewModel.direction {
        case .forward:
            return .asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity)
            )
        case .backward:
            return .asymmetric(
                insertion: .move(edge: .leading).combined(with: .opacity),
                removal: .move(edge: .trailing).combined(with: .opacity)
            )
        }
    }
}
