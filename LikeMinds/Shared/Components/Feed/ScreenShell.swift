import SwiftUI

/// Standard immersive screen wrapper for main app tabs.
struct ScreenShell<Content: View>: View {
    var title: String?
    var showOrbs: Bool = true
    @ViewBuilder var content: () -> Content

    var body: some View {
        ZStack {
            GradientBackground()
            if showOrbs {
                FloatingOrbs(orbs: FloatingOrbs.welcomePreset)
                    .opacity(0.4)
            }
            content()
        }
        .preferredColorScheme(.dark)
    }
}
