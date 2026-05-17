import SwiftUI

struct DiscoverPersonCard: View {
    let person: LMDiscoverPerson
    var onConnect: (() -> Void)?

    var body: some View {
        GlassCard(cornerRadius: Theme.Layout.cornerRadiusLarge) {
            VStack(spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    LinearGradient(
                        colors: [Theme.Colors.accentViolet.opacity(0.5), Theme.Colors.accentCoral.opacity(0.4)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 120)

                    Text("\(person.matchScore)% vibe")
                        .font(Theme.Typography.caption(11))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(.black.opacity(0.35)))
                        .padding(12)
                }

                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Theme.Colors.glassFill)
                            .frame(width: 72, height: 72)
                            .overlay(Circle().stroke(Theme.Colors.heroGradient, lineWidth: 2))
                        Image(systemName: person.avatarSymbol)
                            .font(.system(size: 32))
                            .foregroundStyle(.white.opacity(0.9))
                    }
                    .offset(y: -44)
                    .padding(.bottom, -32)

                    Text("\(person.name), \(person.age)")
                        .font(Theme.Typography.title(22))
                        .foregroundStyle(Theme.Colors.textPrimary)

                    Text(person.city)
                        .font(Theme.Typography.caption(13))
                        .foregroundStyle(Theme.Colors.textTertiary)

                    Text(person.bio)
                        .font(Theme.Typography.body(14))
                        .foregroundStyle(Theme.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                        .padding(.horizontal, 8)

                    VibeTagRow(tags: person.vibeTags)

                    Text("\(person.mutualCount) mutual interests")
                        .font(Theme.Typography.caption(12))
                        .foregroundStyle(Theme.Colors.accentCyan)

                    Button {
                        onConnect?()
                    } label: {
                        Text("Same vibe — say hi")
                            .font(Theme.Typography.button())
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Capsule().fill(Theme.Colors.buttonGradient))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    DiscoverPersonCard(person: MockData.discoverPeople[0])
        .padding()
        .background(Color.black)
}
