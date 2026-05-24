import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: MainTab = .home
    @State private var showNotifications = false

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .home:
                    NavigationStack {
                        HomeFeedView(onNotifications: { showNotifications = true })
                            .navigationDestination(for: LMCommunity.self) { community in
                                CommunityDetailView(community: community)
                            }
                    }
                case .communities:
                    CommunitiesView()
                case .meetups:
                    MeetupsView()
                case .discover:
                    DiscoverPeopleView()
                case .profile:
                    ProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            MainTabBar(selection: $selectedTab)
        }
        .sheet(isPresented: $showNotifications) {
            NotificationsView()
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthManager())
}
