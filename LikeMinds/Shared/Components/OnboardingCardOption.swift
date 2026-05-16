import SwiftUI

struct OnboardingCardOption: View {
    let title: String
    let subtitle: String
    var symbolName: String
    var isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            isSelected
                                ? AnyShapeStyle(Theme.Colors.buttonGradient)
                                : AnyShapeStyle(Theme.Colors.glassFill)
                        )
                        .frame(width: 48, height: 48)
                    Image(systemName: symbolName)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(Theme.Typography.title(17))
                        .foregroundStyle(Theme.Colors.textPrimary)
                    Text(subtitle)
                        .font(Theme.Typography.caption(13))
                        .foregroundStyle(Theme.Colors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22))
                    .foregroundStyle(isSelected ? Theme.Colors.accentCyan : Theme.Colors.textTertiary)
            }
            .padding(18)
            .background {
                RoundedRectangle(cornerRadius: Theme.Layout.cornerRadiusMedium, style: .continuous)
                    .fill(Theme.Colors.glassFill.opacity(isSelected ? 0.22 : 0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Layout.cornerRadiusMedium, style: .continuous)
                            .stroke(
                                isSelected ? Theme.Colors.accentCyan.opacity(0.55) : Theme.Colors.glassStroke.opacity(0.3),
                                lineWidth: isSelected ? 1.5 : 1
                            )
                    )
            }
        }
        .buttonStyle(.plain)
        .animation(Theme.Layout.springBouncy, value: isSelected)
    }
}
