import SwiftUI

struct SecondaryButton: View {
    let title: String
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(Theme.Typography.button())
                .foregroundStyle(Theme.Colors.textPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background {
                    RoundedRectangle(cornerRadius: Theme.Layout.cornerRadiusPill, style: .continuous)
                        .stroke(Theme.Colors.glassStroke.opacity(0.5), lineWidth: 1)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.Layout.cornerRadiusPill, style: .continuous)
                                .fill(Theme.Colors.glassFill.opacity(0.5))
                        )
                }
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.45)
    }
}
