import SwiftUI

@MainActor
final class HomeFeedViewModel: ObservableObject {
    @Published private(set) var featuredCommunities: [LMCommunity] = []
    @Published private(set) var trendingMeetups: [LMMeetup] = []
    @Published private(set) var nearbyMeetups: [LMMeetup] = []
    @Published private(set) var friendActivity: [LMFeedActivity] = []
    @Published private(set) var recommendations: [LMFeedRecommendation] = []

    func load() {
        featuredCommunities = Array(MockData.communities.prefix(5))
        trendingMeetups = MockData.meetups.filter(\.isTrending)
        nearbyMeetups = MockData.meetups
        friendActivity = MockData.feedActivity
        recommendations = MockData.recommendations
    }
}
