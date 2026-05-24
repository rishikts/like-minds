import SwiftUI

struct HomeFeedView: View {
    @StateObject private var viewModel = HomeFeedViewModel()
    var onNotifications: () -> Void = {}

    @State private var appeared = false

    var body: some View {
        ScreenShell {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 28) {
                    header
                    recommendationsSection
                    communitiesSection
                    meetupsSection
                    nearbySection
                    activitySection
                }
                .padding(.horizontal, Theme.Layout.horizontalPadding)
                .padding(.top, 8)
                .padding(.bottom, 100)
            }
        }
        .onAppear {
            viewModel.load()
            withAnimation(Theme.Layout.springSmooth.delay(0.1)) { appeared = true }
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Like Minds")
                    .font(Theme.Typography.display(28))
                    .foregroundStyle(
                        LinearGradient(colors: [.white, Theme.Colors.accentCyan.opacity(0.9)], startPoint: .leading, endPoint: .trailing)
                    )
                Text("Find your people today")
                    .font(Theme.Typography.caption(14))
                    .foregroundStyle(Theme.Colors.textSecondary)
            }
            Spacer()
            Button(action: onNotifications) {
                Image(systemName: "bell.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(Theme.Colors.textPrimary)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(Theme.Colors.glassFill))
            }
        }
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 12)
    }

    private var recommendationsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeaderView(title: "For you")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.recommendations) { item in
                        FeedRecommendationCard(item: item)
                    }
                }
            }
        }
    }

    private var communitiesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeaderView(title: "Featured communities", actionTitle: "See all") {}
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(viewModel.featuredCommunities) { community in
                        NavigationLink(value: community) {
                            CommunityCategoryCard(community: community)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var meetupsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeaderView(title: "Trending meetups")
            ForEach(viewModel.trendingMeetups) { meetup in
                MeetupCard(meetup: meetup)
            }
        }
    }

    private var nearbySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeaderView(title: "Nearby activities")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(viewModel.nearbyMeetups) { meetup in
                        MeetupCard(meetup: meetup)
                            .frame(width: 300)
                    }
                }
            }
        }
    }

    private var activitySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeaderView(title: "Friend activity")
            ForEach(viewModel.friendActivity) { activity in
                ActivityRowCard(activity: activity)
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeFeedView()
    }
}
