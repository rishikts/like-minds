import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var profile: LMUserProfile = MockData.currentUser
    @Published private(set) var isLoading = false
    @Published var loadError: String?

    private let userProfileService: UserProfileServing

    init(userProfileService: UserProfileServing = UserProfileService()) {
        self.userProfileService = userProfileService
    }

    func load(session: UserSession?) {
        guard let session else {
            profile = MockData.currentUser
            return
        }

        profile = UserProfileMapper.lmProfile(session: session)

        guard APIConfig.syncAPIKey != nil else { return }

        isLoading = true
        loadError = nil
        Task {
            defer { isLoading = false }
            do {
                let dto = try await userProfileService.fetchProfile(externalAuthId: session.user.id)
                profile = UserProfileMapper.lmProfile(from: dto)
            } catch {
                loadError = error.localizedDescription
                profile = UserProfileMapper.lmProfile(session: session)
            }
        }
    }
}
