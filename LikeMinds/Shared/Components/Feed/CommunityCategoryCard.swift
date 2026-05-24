import SwiftUI

struct CommunityCategoryCard: View {
    let community: LMCommunity

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: Theme.Layout.cornerRadiusLarge, style: .continuous)
                .fill(gradient)
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Layout.cornerRadiusLarge, style: .continuous)
                        .fill(.black.opacity(0.25))
                )

            Image(systemName: community.iconName)
                .font(.system(size: 36, weight: .semibold))
                .foregroundStyle(.white.opacity(0.35))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(16)

            VStack(alignment: .leading, spacing: 6) {
                Text(community.category)
                    .font(Theme.Typography.caption(11))
                    .foregroundStyle(.white.opacity(0.75))
                Text(community.name)
                    .font(Theme.Typography.title(17))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                Text("\(community.memberCount.formatted()) members")
                    .font(Theme.Typography.caption(12))
                    .foregroundStyle(.white.opacity(0.7))
            }
            .padding(16)
        }
    }

    private var gradient: LinearGradient {
        let colors = community.gradientColors.compactMap { Theme.Colors.named($0) }
        return LinearGradient(
            colors: colors.isEmpty ? [Theme.Colors.accentViolet, Theme.Colors.accentCoral] : colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

#Preview {
    CommunityCategoryCard(community: MockData.communities[0])
        .padding()
        .background(Color.black)
}
