import SwiftUI

struct MeetupCard: View {
    let meetup: LMMeetup
    var onRSVP: (() -> Void)?

    var body: some View {
        GlassCard(cornerRadius: Theme.Layout.cornerRadiusLarge) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(Theme.Colors.glassFill)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(Theme.Colors.accentViolet.opacity(0.35))
                            )
                            .frame(width: 52, height: 52)
                        Image(systemName: meetup.imageSymbol)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        if meetup.isTrending {
                            Text("TRENDING")
                                .font(Theme.Typography.caption(10))
                                .foregroundStyle(Theme.Colors.accentGold)
                        }
                        Text(meetup.title)
                            .font(Theme.Typography.title(17))
                            .foregroundStyle(Theme.Colors.textPrimary)
                            .lineLimit(2)
                    }
                    Spacer(minLength: 0)
                }

                Label(meetup.location, systemImage: "mappin.and.ellipse")
                    .font(Theme.Typography.caption(13))
                    .foregroundStyle(Theme.Colors.textSecondary)

                HStack {
                    Label(meetup.date.formatted(date: .abbreviated, time: .shortened), systemImage: "calendar")
                    Spacer()
                    Label("\(meetup.attendeeCount)/\(meetup.maxAttendees)", systemImage: "person.2.fill")
                }
                .font(Theme.Typography.caption(12))
                .foregroundStyle(Theme.Colors.textTertiary)

                VibeTagRow(tags: meetup.vibeTags)

                Button {
                    onRSVP?()
                } label: {
                    Text("RSVP")
                        .font(Theme.Typography.caption(14))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Theme.Colors.buttonGradient)
                        )
                }
                .buttonStyle(.plain)
            }
            .padding(16)
        }
    }
}

#Preview {
    MeetupCard(meetup: MockData.meetups[0])
        .padding()
        .background(Color.black)
}
