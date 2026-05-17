import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var profile: LMUserProfile = MockData.currentUser

    func load() {
        profile = MockData.currentUser
    }
}
