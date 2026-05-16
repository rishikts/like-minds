import SwiftUI

struct OnboardingMultilineField: View {
    let placeholder: String
    @Binding var text: String
    var characterLimit: Int = 280

    private var remaining: Int { max(0, characterLimit - text.count) }

    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(Theme.Typography.body(16))
                        .foregroundStyle(Theme.Colors.textTertiary)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 18)
                }

                TextEditor(text: $text)
                    .font(Theme.Typography.body(16))
                    .foregroundStyle(Theme.Colors.textPrimary)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .frame(minHeight: 140)
                    .onChange(of: text) { _, newValue in
                        if newValue.count > characterLimit {
                            text = String(newValue.prefix(characterLimit))
                        }
                    }
            }
            .background {
                RoundedRectangle(cornerRadius: Theme.Layout.cornerRadiusMedium, style: .continuous)
                    .fill(Theme.Colors.glassFill)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Layout.cornerRadiusMedium, style: .continuous)
                            .stroke(Theme.Colors.glassStroke.opacity(0.35), lineWidth: 1)
                    )
            }

            Text("\(remaining) characters left")
                .font(Theme.Typography.caption(12))
                .foregroundStyle(remaining < 30 ? Theme.Colors.accentCoral : Theme.Colors.textTertiary)
        }
    }
}
