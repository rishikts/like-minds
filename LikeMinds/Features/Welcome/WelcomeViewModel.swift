import SwiftUI

@MainActor
final class WelcomeViewModel: ObservableObject {
    @Published private(set) var hasAppeared = false
    @Published private(set) var isTransitioning = false

    let heading = "Welcome to\nLike Minds"
    let caption =
        "Discover people who share your passions—turn hobbies into friendships, communities into belonging, and everyday moments into memories you'll actually live."

    var onGetStarted: (() -> Void)?

    func onAppear() {
        guard !hasAppeared else { return }
        withAnimation(Theme.Layout.easeOutLong) {
            hasAppeared = true
        }
    }

    func getStartedTapped() {
        guard !isTransitioning else { return }
        withAnimation(Theme.Layout.springBouncy) {
            isTransitioning = true
        }
        onGetStarted?()
    }
}
