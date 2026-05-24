import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var authManager: AuthManager
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showEdit = false

    var body: some View {
        NavigationStack {
            ScreenShell {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        header
                        statsRow
                        bioSection
                        vibesSection
                        interestsSection
                        communitiesSection
                        badgesSection
                        SecondaryButton(title: "Sign Out") { authManager.signOut() }
                    }
                    .padding(.horizontal, Theme.Layout.horizontalPadding)
                    .padding(.top, 8)
                    .padding(.bottom, 100)
                }
            }
            .navigationDestination(isPresented: $showEdit) {
                EditInterestsView(profile: viewModel.profile)
            }
        }
        .onAppear { viewModel.load(session: authManager.session) }
    }

    private var header: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Theme.Colors.glassFill)
                    .frame(width: 100, height: 100)
                    .overlay(Circle().stroke(Theme.Colors.heroGradient, lineWidth: 3))
                Image(systemName: viewModel.profile.avatarSymbol)
                    .font(.system(size: 44))
                    .foregroundStyle(.white)
            }
            Text(viewModel.profile.name)
                .font(Theme.Typography.display(28))
                .foregroundStyle(.white)
            Text("@\(viewModel.profile.username)")
                .font(Theme.Typography.caption(14))
                .foregroundStyle(Theme.Colors.textTertiary)
            Button("Edit profile") { showEdit = true }
                .font(Theme.Typography.caption(14))
                .foregroundStyle(Theme.Colors.accentCyan)
        }
    }

    private var statsRow: some View {
        HStack(spacing: 12) {
            statCard(value: "\(viewModel.profile.meetupsAttended)", label: "Attended")
            statCard(value: "\(viewModel.profile.meetupsHosted)", label: "Hosted")
            statCard(value: viewModel.profile.socialComfort, label: "Energy")
        }
    }

    private func statCard(value: String, label: String) -> some View {
        GlassCard(cornerRadius: 16) {
            VStack(spacing: 6) {
                Text(value)
                    .font(Theme.Typography.title(16))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
                    .multilineTextAlignment(.center)
                Text(label)
                    .font(Theme.Typography.caption(11))
                    .foregroundStyle(Theme.Colors.textTertiary)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 8)
            .padding(.vertical, 14)
        }
    }

    private var bioSection: some View {
        sectionBlock(title: "About") {
            Text(viewModel.profile.bio)
                .font(Theme.Typography.body(15))
                .foregroundStyle(Theme.Colors.textSecondary)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var vibesSection: some View {
        sectionBlock(title: "Your vibe") {
            profileTagFlow(viewModel.profile.vibeTags)
        }
    }

    private var interestsSection: some View {
        sectionBlock(title: "Interests") {
            profileTagFlow(viewModel.profile.interests)
        }
    }

    private var communitiesSection: some View {
        sectionBlock(title: "Favorite communities") {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(viewModel.profile.favoriteCommunities, id: \.self) { name in
                    Text(name)
                        .font(Theme.Typography.caption(14))
                        .foregroundStyle(Theme.Colors.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    private var badgesSection: some View {
        sectionBlock(title: "Badges") {
            profileTagFlow(viewModel.profile.badges, accent: true)
        }
    }

    private func profileTagFlow(_ tags: [String], accent: Bool = false) -> some View {
        FlowLayout(spacing: 10) {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .font(Theme.Typography.caption(13))
                    .foregroundStyle(accent ? Theme.Colors.accentGold : Theme.Colors.textSecondary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 9)
                    .background {
                        Capsule(style: .continuous)
                            .fill(Theme.Colors.glassFill)
                            .overlay(
                                Capsule(style: .continuous)
                                    .stroke(
                                        accent ? Theme.Colors.accentGold.opacity(0.45) : Theme.Colors.glassStroke.opacity(0.3),
                                        lineWidth: 1
                                    )
                            )
                    }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func sectionBlock<Content: View>(title: String, @ViewBuilder content: @escaping () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeaderView(title: title)
            GlassCard(cornerRadius: Theme.Layout.cornerRadiusMedium) {
                content()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(18)
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthManager())
}
