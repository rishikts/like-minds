import SwiftUI

struct OnboardingStepHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(Theme.Typography.display(30))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, Theme.Colors.accentCyan.opacity(0.85)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .fixedSize(horizontal: false, vertical: true)

            Text(subtitle)
                .font(Theme.Typography.body(16))
                .foregroundStyle(Theme.Colors.textSecondary)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
