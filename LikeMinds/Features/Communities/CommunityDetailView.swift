import SwiftUI

struct CommunityDetailView: View {
    @StateObject private var viewModel: CommunityDetailViewModel

    init(community: LMCommunity) {
        _viewModel = StateObject(wrappedValue: CommunityDetailViewModel(community: community))
    }

    var body: some View {
        ScreenShell(showOrbs: false) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    banner
                    Text(viewModel.community.description)
                        .font(Theme.Typography.body(16))
                        .foregroundStyle(Theme.Colors.textSecondary)
                        .lineSpacing(4)

                    VibeTagRow(tags: viewModel.community.vibeTags)

                    membersPreview

                    if !viewModel.upcomingMeetups.isEmpty {
                        SectionHeaderView(title: "Upcoming meetups")
                        ForEach(viewModel.upcomingMeetups) { meetup in
                            MeetupCard(meetup: meetup)
                        }
                    }
                }
                .padding(.horizontal, Theme.Layout.horizontalPadding)
                .padding(.bottom, 40)
            }
        }
        .safeAreaInset(edge: .bottom) {
            PrimaryButton(title: viewModel.hasJoined ? "Joined ✓" : "Join community") {
                viewModel.toggleJoin()
            }
            .padding(.horizontal, Theme.Layout.horizontalPadding)
            .padding(.bottom, 12)
            .background(.ultraThinMaterial)
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { viewModel.load() }
    }

    private var banner: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: Theme.Layout.cornerRadiusLarge, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Theme.Colors.accentViolet, Theme.Colors.accentCoral],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 200)
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.community.category)
                    .font(Theme.Typography.caption(12))
                    .foregroundStyle(.white.opacity(0.8))
                Text(viewModel.community.name)
                    .font(Theme.Typography.display(28))
                    .foregroundStyle(.white)
                Text("\(viewModel.community.memberCount.formatted()) members")
                    .font(Theme.Typography.caption(13))
                    .foregroundStyle(.white.opacity(0.75))
            }
            .padding(20)
        }
    }

    private var membersPreview: some View {
        HStack(spacing: -12) {
            ForEach(0..<5, id: \.self) { i in
                Circle()
                    .fill(Theme.Colors.glassFill)
                    .frame(width: 40, height: 40)
                    .overlay(Image(systemName: "person.fill").foregroundStyle(.white.opacity(0.8)))
                    .overlay(Circle().stroke(Color.black.opacity(0.3), lineWidth: 2))
            }
            Text("+ \(viewModel.community.memberCount - 5) more")
                .font(Theme.Typography.caption(13))
                .foregroundStyle(Theme.Colors.textTertiary)
                .padding(.leading, 16)
        }
    }
}

#Preview {
    NavigationStack {
        CommunityDetailView(community: MockData.communities[0])
    }
}
