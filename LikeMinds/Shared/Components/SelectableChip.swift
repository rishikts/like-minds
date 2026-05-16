import SwiftUI

struct SelectableChip: View {
    let title: String
    var symbolName: String?
    var isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let symbolName {
                    Image(systemName: symbolName)
                        .font(.system(size: 12, weight: .semibold))
                }
                Text(title)
                    .font(Theme.Typography.caption(14))
            }
            .foregroundStyle(isSelected ? .white : Theme.Colors.textSecondary)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background {
                Capsule(style: .continuous)
                    .fill(isSelected ? AnyShapeStyle(Theme.Colors.buttonGradient) : AnyShapeStyle(Theme.Colors.glassFill))
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(
                                isSelected ? Color.clear : Theme.Colors.glassStroke.opacity(0.4),
                                lineWidth: 1
                            )
                    )
            }
        }
        .buttonStyle(.plain)
        .animation(Theme.Layout.springBouncy, value: isSelected)
    }
}
