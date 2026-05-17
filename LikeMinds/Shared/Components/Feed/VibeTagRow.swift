import SwiftUI

struct VibeTagRow: View {
    let tags: [String]
    var limit: Int = 4

    var body: some View {
        HStack(spacing: 8) {
            ForEach(tags.prefix(limit), id: \.self) { tag in
                Text(tag)
                    .font(Theme.Typography.caption(11))
                    .foregroundStyle(Theme.Colors.textSecondary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(Theme.Colors.glassFill))
            }
        }
    }
}
