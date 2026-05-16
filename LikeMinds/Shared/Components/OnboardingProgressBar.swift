import SwiftUI

struct OnboardingProgressBar: View {
    let current: Int
    let total: Int

    private var progress: CGFloat {
        guard total > 0 else { return 0 }
        return CGFloat(current) / CGFloat(total)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Step \(current) of \(total)")
                    .font(Theme.Typography.caption(12))
                    .foregroundStyle(Theme.Colors.textTertiary)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(Theme.Typography.caption(12))
                    .foregroundStyle(Theme.Colors.accentCyan.opacity(0.9))
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Theme.Colors.glassFill)
                    Capsule()
                        .fill(Theme.Colors.heroGradient)
                        .frame(width: max(8, geo.size.width * progress))
                        .animation(Theme.Layout.springSmooth, value: progress)
                }
            }
            .frame(height: 5)
        }
    }
}
