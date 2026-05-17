import SwiftUI

@MainActor
final class CommunityDetailViewModel: ObservableObject {
    let community: LMCommunity
    @Published private(set) var upcomingMeetups: [LMMeetup] = []
    @Published var hasJoined = false

    init(community: LMCommunity) {
        self.community = community
    }

    func load() {
        upcomingMeetups = MockData.meetups.filter { $0.communityName == community.name }
    }

    func toggleJoin() {
        hasJoined.toggle()
    }
}
