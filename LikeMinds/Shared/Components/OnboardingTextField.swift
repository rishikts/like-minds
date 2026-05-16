import SwiftUI

struct OnboardingTextField: View {
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType?
    var autocapitalization: TextInputAutocapitalization = .sentences

    var body: some View {
        TextField(placeholder, text: $text)
            .font(Theme.Typography.body(18))
            .foregroundStyle(Theme.Colors.textPrimary)
            .textInputAutocapitalization(autocapitalization)
            .keyboardType(keyboardType)
            .textContentType(textContentType)
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .background {
                RoundedRectangle(cornerRadius: Theme.Layout.cornerRadiusMedium, style: .continuous)
                    .fill(Theme.Colors.glassFill)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Layout.cornerRadiusMedium, style: .continuous)
                            .stroke(Theme.Colors.glassStroke.opacity(0.35), lineWidth: 1)
                    )
            }
    }
}
