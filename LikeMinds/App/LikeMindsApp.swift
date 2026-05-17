import SwiftUI

#if canImport(GoogleSignIn)
import GoogleSignIn
#endif

@main
struct LikeMindsApp: App {
    init() {
        _ = GoogleSignInConfiguration.configure()
    }

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .onOpenURL(perform: handleIncomingURL)
        }
    }

    private func handleIncomingURL(_ url: URL) {
        #if canImport(GoogleSignIn)
        _ = GIDSignIn.sharedInstance.handle(url)
        #endif
    }
}
