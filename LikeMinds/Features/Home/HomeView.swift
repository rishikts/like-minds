import SwiftUI

/// Main app shell after onboarding — tab navigation + mock feed UI.
struct HomeView: View {
    var body: some View {
        MainTabView()
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthManager())
}
