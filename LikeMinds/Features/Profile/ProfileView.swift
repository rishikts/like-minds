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
        .onAppear { viewModel.load() }
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
            VStack(spacing: 4) {
                Text(value)
                    .font(Theme.Typography.title(18))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Text(label)
                    .font(Theme.Typography.caption(11))
                    .foregroundStyle(Theme.Colors.textTertiary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
        }
    }

    private var bioSection: some View {
        sectionBlock(title: "About") {
            Text(viewModel.profile.bio)
                .font(Theme.Typography.body(15))
                .foregroundStyle(Theme.Colors.textSecondary)
                .lineSpacing(4)
        }
    }

    private var vibesSection: some View {
        sectionBlock(title: "Your vibe") {
            VibeTagRow(tags: viewModel.profile.vibeTags, limit: 6)
        }
    }

    private var interestsSection: some View {
        sectionBlock(title: "Interests") {
            FlowLayout(spacing: 8) {
                ForEach(viewModel.profile.interests, id: \.self) { interest in
                    Text(interest)
                        .font(Theme.Typography.caption(13))
                        .foregroundStyle(Theme.Colors.textSecondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Capsule().fill(Theme.Colors.glassFill))
                }
            }
        }
    }

    private var communitiesSection: some View {
        sectionBlock(title: "Favorite communities") {
            ForEach(viewModel.profile.favoriteCommunities, id: \.self) { name in
                Text(name)
                    .font(Theme.Typography.caption(14))
                    .foregroundStyle(Theme.Colors.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 6)
            }
        }
    }

    private var badgesSection: some View {
        sectionBlock(title: "Badges") {
            HStack(spacing: 10) {
                ForEach(viewModel.profile.badges, id: \.self) { badge in
                    Text(badge)
                        .font(Theme.Typography.caption(11))
                        .foregroundStyle(Theme.Colors.accentGold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Capsule().stroke(Theme.Colors.accentGold.opacity(0.5), lineWidth: 1))
                }
            }
        }
    }

    private func sectionBlock<Content: View>(title: String, @ViewBuilder content: @escaping () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeaderView(title: title)
            GlassCard(cornerRadius: Theme.Layout.cornerRadiusMedium, content: content)
                .padding(16)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthManager())
}
