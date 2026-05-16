import SwiftUI

#if canImport(GoogleSignIn)
import GoogleSignIn
#endif

@main
struct LikeMindsApp: App {
    init() {
        configureGoogleSignInIfAvailable()
    }

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .onOpenURL(perform: handleIncomingURL)
        }
    }

    private func configureGoogleSignInIfAvailable() {
        #if canImport(GoogleSignIn)
        guard let clientID = Bundle.main.object(forInfoDictionaryKey: "GIDClientID") as? String else {
            return
        }
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        #endif
    }

    private func handleIncomingURL(_ url: URL) {
        #if canImport(GoogleSignIn)
        _ = GIDSignIn.sharedInstance.handle(url)
        #endif
    }
}
