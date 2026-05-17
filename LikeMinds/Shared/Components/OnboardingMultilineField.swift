import SwiftUI

struct OnboardingMultilineField: View {
    let placeholder: String
    @Binding var text: String
    var characterLimit: Int = 280

    private var remaining: Int { max(0, characterLimit - text.count) }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: Theme.Layout.cornerRadiusMedium, style: .continuous)
                    .fill(Theme.Colors.glassFill)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Layout.cornerRadiusMedium, style: .continuous)
                            .stroke(Theme.Colors.glassStroke.opacity(0.35), lineWidth: 1)
                    )

                TextEditor(text: $text)
                    .font(Theme.Typography.body(16))
                    .foregroundStyle(Theme.Colors.textPrimary)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 14)
                    .frame(minHeight: 120)

                if text.isEmpty {
                    Text(placeholder)
                        .font(Theme.Typography.body(16))
                        .foregroundStyle(Theme.Colors.textTertiary)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 22)
                        .allowsHitTesting(false)
                }
            }
            .frame(minHeight: 120)
            .onChange(of: text) { _, newValue in
                if newValue.count > characterLimit {
                    text = String(newValue.prefix(characterLimit))
                }
            }

            Text("\(remaining) characters left")
                .font(Theme.Typography.caption(12))
                .foregroundStyle(remaining < 30 ? Theme.Colors.accentCoral : Theme.Colors.textTertiary)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}
