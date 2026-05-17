import SwiftUI

struct FeedRecommendationCard: View {
    let item: LMFeedRecommendation

    var body: some View {
        GlassCard(cornerRadius: Theme.Layout.cornerRadiusMedium) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Theme.Colors.buttonGradient)
                        .frame(width: 44, height: 44)
                    Image(systemName: item.iconName)
                        .foregroundStyle(.white)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(Theme.Typography.title(16))
                        .foregroundStyle(Theme.Colors.textPrimary)
                    Text(item.subtitle)
                        .font(Theme.Typography.caption(13))
                        .foregroundStyle(Theme.Colors.textSecondary)
                        .lineLimit(2)
                }
                Spacer()
                Text(item.cta)
                    .font(Theme.Typography.caption(13))
                    .foregroundStyle(Theme.Colors.accentCyan)
            }
            .padding(16)
        }
        .frame(width: 300)
    }
}
