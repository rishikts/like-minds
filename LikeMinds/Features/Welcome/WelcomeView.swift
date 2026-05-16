import SwiftUI

struct WelcomeView: View {
    @ObservedObject var viewModel: WelcomeViewModel

    @State private var headingOffset: CGFloat = 28
    @State private var contentOpacity: Double = 0
    @State private var buttonOffset: CGFloat = 24

    var body: some View {
        ZStack {
            GradientBackground()

            FloatingOrbs(orbs: FloatingOrbs.welcomePreset)

            VStack(spacing: 0) {
                Spacer(minLength: 12)

                heroSection
                    .padding(.bottom, Theme.Layout.sectionSpacing)

                copySection
                    .padding(.horizontal, Theme.Layout.horizontalPadding)
                    .padding(.bottom, Theme.Layout.sectionSpacing)

                Spacer(minLength: 8)

                ctaSection
                    .padding(.horizontal, Theme.Layout.horizontalPadding)
                    .padding(.bottom, 16)
            }
        }
        .preferredColorScheme(.dark)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Welcome to Like Minds")
        .onAppear {
            viewModel.onAppear()
            runEntranceAnimations()
        }
    }

    // MARK: - Sections

    private var heroSection: some View {
        VStack(spacing: 20) {
            ConnectionHub(badges: ConnectionHub.welcomePreset)
                .opacity(viewModel.hasAppeared ? 1 : 0)
                .scaleEffect(viewModel.hasAppeared ? 1 : 0.9)

            connectionPill
        }
    }

    private var connectionPill: some View {
        HStack(spacing: 8) {
            Image(systemName: "sparkles")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(Theme.Colors.accentGold)

            Text("Where kindred spirits meet")
                .font(Theme.Typography.caption(13))
                .foregroundStyle(Theme.Colors.textSecondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background {
            Capsule()
                .fill(Theme.Colors.glassFill)
                .overlay(
                    Capsule()
                        .stroke(Theme.Colors.glassStroke.opacity(0.5), lineWidth: 1)
                )
        }
        .opacity(contentOpacity)
    }

    private var copySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(viewModel.heading)
                .font(Theme.Typography.display(36))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            .white,
                            .white.opacity(0.92),
                            Theme.Colors.accentCyan.opacity(0.85)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
                .offset(y: headingOffset)
                .opacity(contentOpacity)

            Text(viewModel.caption)
                .font(Theme.Typography.body(16))
                .foregroundStyle(Theme.Colors.textSecondary)
                .lineSpacing(6)
                .fixedSize(horizontal: false, vertical: true)
                .opacity(contentOpacity * 0.95)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var ctaSection: some View {
        VStack(spacing: 20) {
            GlassCard(cornerRadius: Theme.Layout.cornerRadiusMedium) {
                HStack(spacing: 14) {
                    trustAvatars

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Join 12k+ explorers")
                            .font(Theme.Typography.caption(14))
                            .foregroundStyle(Theme.Colors.textPrimary)

                        Text("Finding their people this week")
                            .font(Theme.Typography.caption(12))
                            .foregroundStyle(Theme.Colors.textTertiary)
                    }

                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 14)
            }
            .opacity(contentOpacity)

            PrimaryButton(
                title: "Get Started",
                isEnabled: !viewModel.isTransitioning
            ) {
                viewModel.getStartedTapped()
            }
            .offset(y: buttonOffset)
            .opacity(contentOpacity)
            .sensoryFeedback(.impact(weight: .medium), trigger: viewModel.isTransitioning)
            .accessibilityLabel("Get Started")
            .accessibilityHint("Begin exploring Like Minds")

            Text("Free to join · Real connections · Your vibe")
                .font(Theme.Typography.caption(12))
                .foregroundStyle(Theme.Colors.textTertiary)
                .opacity(contentOpacity * 0.85)
        }
    }

    private var trustAvatars: some View {
        HStack(spacing: -10) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(
                        LinearGradient(
                            colors: avatarColors(for: index),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 32, height: 32)
                    .overlay(
                        Circle()
                            .stroke(Color.black.opacity(0.35), lineWidth: 2)
                    )
                    .overlay {
                        Image(systemName: avatarSymbol(for: index))
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.9))
                    }
            }
        }
    }

    // MARK: - Animation

    private func runEntranceAnimations() {
        withAnimation(Theme.Layout.springSmooth.delay(0.25)) {
            headingOffset = 0
            contentOpacity = 1
        }
        withAnimation(Theme.Layout.springSmooth.delay(0.42)) {
            buttonOffset = 0
        }
    }

    // MARK: - Helpers

    private func avatarColors(for index: Int) -> [Color] {
        switch index {
        case 0: [Theme.Colors.accentViolet, Theme.Colors.accentCoral]
        case 1: [Theme.Colors.accentCyan, Theme.Colors.accentViolet]
        default: [Theme.Colors.accentGold, Theme.Colors.accentCoral]
        }
    }

    private func avatarSymbol(for index: Int) -> String {
        switch index {
        case 0: "person.fill"
        case 1: "heart.fill"
        default: "star.fill"
        }
    }
}

#Preview("Welcome") {
    WelcomeView(viewModel: WelcomeViewModel())
}

#Preview("Welcome — Large") {
    WelcomeView(viewModel: WelcomeViewModel())
        .previewLayout(.fixed(width: 430, height: 932))
}
