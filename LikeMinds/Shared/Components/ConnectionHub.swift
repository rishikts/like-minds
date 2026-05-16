import SwiftUI

struct CommunityBadge: Identifiable {
    let id = UUID()
    let symbol: String
    let label: String
    let color: Color
    let angle: Double
    let orbitRadius: CGFloat
}

struct ConnectionHub: View {
    let badges: [CommunityBadge]
    @State private var rotation: Double = 0
    @State private var pulse = false
    @State private var appeared = false

    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    AngularGradient(
                        colors: [
                            Theme.Colors.accentViolet.opacity(0.6),
                            Theme.Colors.accentCoral.opacity(0.5),
                            Theme.Colors.accentCyan.opacity(0.5),
                            Theme.Colors.accentViolet.opacity(0.6)
                        ],
                        center: .center
                    ),
                    lineWidth: 1.5
                )
                .frame(width: 200, height: 200)
                .blur(radius: 0.5)
                .opacity(appeared ? 0.9 : 0)
                .scaleEffect(pulse ? 1.03 : 0.97)
                .animation(.easeInOut(duration: 3.2).repeatForever(autoreverses: true), value: pulse)

            Circle()
                .fill(Theme.Colors.ambientGlow)
                .frame(width: 120, height: 120)
                .scaleEffect(pulse ? 1.08 : 0.95)

            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .stroke(Theme.Colors.glassStroke.opacity(0.35), lineWidth: 1)
                    .frame(width: CGFloat(90 + index * 36))
            }

            Image(systemName: "person.2.fill")
                .font(.system(size: 36, weight: .semibold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, Theme.Colors.accentCyan.opacity(0.9)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Theme.Colors.accentViolet.opacity(0.6), radius: 16)

            ForEach(badges) { badge in
                badgeView(badge)
            }
        }
        .frame(width: 240, height: 240)
        .rotationEffect(.degrees(rotation))
        .scaleEffect(appeared ? 1 : 0.82)
        .opacity(appeared ? 1 : 0)
        .onAppear {
            pulse = true
            withAnimation(Theme.Layout.springSmooth.delay(0.15)) {
                appeared = true
            }
            withAnimation(.linear(duration: 28).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }

    @ViewBuilder
    private func badgeView(_ badge: CommunityBadge) -> some View {
        let radians = badge.angle * .pi / 180
        let x = cos(radians) * badge.orbitRadius
        let y = sin(radians) * badge.orbitRadius

        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(badge.color.opacity(0.22))
                    .frame(width: 48, height: 48)
                    .overlay(
                        Circle()
                            .stroke(badge.color.opacity(0.55), lineWidth: 1)
                    )
                    .shadow(color: badge.color.opacity(0.35), radius: 10)

                Image(systemName: badge.symbol)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
            }

            Text(badge.label)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .foregroundStyle(Theme.Colors.textTertiary)
        }
        .offset(x: x, y: y)
        .rotationEffect(.degrees(-rotation))
    }

    static let welcomePreset: [CommunityBadge] = [
        CommunityBadge(symbol: "music.note", label: "Music", color: Theme.Colors.accentCoral, angle: -50, orbitRadius: 108),
        CommunityBadge(symbol: "camera.fill", label: "Create", color: Theme.Colors.accentViolet, angle: 40, orbitRadius: 112),
        CommunityBadge(symbol: "figure.run", label: "Move", color: Theme.Colors.accentCyan, angle: 140, orbitRadius: 105),
        CommunityBadge(symbol: "leaf.fill", label: "Nature", color: Theme.Colors.accentGold, angle: 210, orbitRadius: 110),
        CommunityBadge(symbol: "gamecontroller.fill", label: "Play", color: Theme.Colors.accentCoral, angle: 290, orbitRadius: 108)
    ]
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ConnectionHub(badges: ConnectionHub.welcomePreset)
    }
}
