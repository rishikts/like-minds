import SwiftUI

@MainActor
final class CommunitiesViewModel: ObservableObject {
    @Published private(set) var communities: [LMCommunity] = []

    func load() {
        communities = MockData.communities
    }
}
