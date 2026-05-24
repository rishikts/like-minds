import SwiftUI

struct NotificationRow: View {
    let item: LMNotificationItem

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                Circle()
                    .fill(item.isUnread ? Theme.Colors.accentViolet.opacity(0.35) : Theme.Colors.glassFill)
                    .frame(width: 44, height: 44)
                Image(systemName: item.iconName)
                    .foregroundStyle(.white.opacity(0.9))
            }
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(item.title)
                        .font(Theme.Typography.title(15))
                        .foregroundStyle(Theme.Colors.textPrimary)
                    Spacer()
                    Text(item.timeAgo)
                        .font(Theme.Typography.caption(11))
                        .foregroundStyle(Theme.Colors.textTertiary)
                }
                Text(item.body)
                    .font(Theme.Typography.caption(13))
                    .foregroundStyle(Theme.Colors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, 4)
        .opacity(item.isUnread ? 1 : 0.85)
    }
}
