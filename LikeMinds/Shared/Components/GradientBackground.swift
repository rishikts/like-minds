import SwiftUI

struct GradientBackground: View {
    @State private var drift: CGFloat = 0

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Theme.Colors.canvasTop, Theme.Colors.canvasBottom],
                startPoint: .top,
                endPoint: .bottom
            )

            Circle()
                .fill(Theme.Colors.accentViolet.opacity(0.35))
                .frame(width: 340, height: 340)
                .blur(radius: 90)
                .offset(x: -80 + drift * 12, y: -220)

            Circle()
                .fill(Theme.Colors.accentCoral.opacity(0.28))
                .frame(width: 280, height: 280)
                .blur(radius: 80)
                .offset(x: 120 - drift * 10, y: -40)

            Circle()
                .fill(Theme.Colors.accentCyan.opacity(0.22))
                .frame(width: 320, height: 320)
                .blur(radius: 100)
                .offset(x: -40 + drift * 8, y: 280)

            EllipticalGradient(
                colors: [
                    Theme.Colors.accentViolet.opacity(0.18),
                    .clear
                ],
                center: .top,
                startRadiusFraction: 0,
                endRadiusFraction: 0.75
            )
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 6).repeatForever(autoreverses: true)) {
                drift = 1
            }
        }
    }
}

#Preview {
    GradientBackground()
}
