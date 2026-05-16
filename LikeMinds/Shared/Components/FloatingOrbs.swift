import SwiftUI

struct FloatingOrb: Identifiable {
    let id = UUID()
    let size: CGFloat
    let color: Color
    let xOffset: CGFloat
    let yOffset: CGFloat
    let duration: Double
    let delay: Double
}

struct FloatingOrbs: View {
    let orbs: [FloatingOrb]
    @State private var animate = false

    var body: some View {
        ZStack {
            ForEach(orbs) { orb in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [orb.color.opacity(0.9), orb.color.opacity(0)],
                            center: .center,
                            startRadius: 0,
                            endRadius: orb.size * 0.5
                        )
                    )
                    .frame(width: orb.size, height: orb.size)
                    .blur(radius: orb.size * 0.08)
                    .offset(
                        x: orb.xOffset,
                        y: orb.yOffset + (animate ? -14 : 14)
                    )
                    .opacity(animate ? 0.85 : 0.55)
                    .animation(
                        .easeInOut(duration: orb.duration)
                            .repeatForever(autoreverses: true)
                            .delay(orb.delay),
                        value: animate
                    )
            }
        }
        .onAppear { animate = true }
    }

    static let welcomePreset: [FloatingOrb] = [
        FloatingOrb(size: 18, color: Theme.Colors.accentCyan, xOffset: -130, yOffset: -60, duration: 4.2, delay: 0),
        FloatingOrb(size: 12, color: Theme.Colors.accentGold, xOffset: 140, yOffset: -30, duration: 3.6, delay: 0.4),
        FloatingOrb(size: 14, color: Theme.Colors.accentCoral, xOffset: -100, yOffset: 80, duration: 5.0, delay: 0.2),
        FloatingOrb(size: 10, color: Theme.Colors.accentViolet, xOffset: 120, yOffset: 100, duration: 4.8, delay: 0.6)
    ]
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        FloatingOrbs(orbs: FloatingOrbs.welcomePreset)
    }
}
