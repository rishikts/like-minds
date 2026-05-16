import SwiftUI

@main
struct LikeMindsApp: App {
    var body: some Scene {
        WindowGroup {
            WelcomeView(viewModel: WelcomeViewModel())
        }
    }
}
