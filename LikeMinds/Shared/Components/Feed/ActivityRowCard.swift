import SwiftUI

struct ActivityRowCard: View {
    let activity: LMFeedActivity

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Theme.Colors.glassFill)
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: activity.avatarSymbol)
                        .foregroundStyle(Theme.Colors.textSecondary)
                )
            VStack(alignment: .leading, spacing: 2) {
                Text("\(activity.userName) \(activity.action) \(activity.communityName)")
                    .font(Theme.Typography.caption(14))
                    .foregroundStyle(Theme.Colors.textPrimary)
                Text(activity.timeAgo)
                    .font(Theme.Typography.caption(11))
                    .foregroundStyle(Theme.Colors.textTertiary)
            }
            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Theme.Colors.glassFill.opacity(0.65))
        )
    }
}
