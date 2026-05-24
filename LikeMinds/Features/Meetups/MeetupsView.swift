import SwiftUI

struct MeetupsView: View {
    @StateObject private var viewModel = MeetupsViewModel()

    var body: some View {
        ScreenShell {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Upcoming meetups")
                        .font(Theme.Typography.display(30))
                        .foregroundStyle(.white)
                    Text("Real plans with real people.")
                        .font(Theme.Typography.body(15))
                        .foregroundStyle(Theme.Colors.textSecondary)

                    ForEach(viewModel.meetups) { meetup in
                        MeetupCard(meetup: meetup) {
                            viewModel.toggleRSVP(meetup.id)
                        }
                        .overlay(alignment: .topTrailing) {
                            if viewModel.rsvpIDs.contains(meetup.id) {
                                Text("Going")
                                    .font(Theme.Typography.caption(11))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Capsule().fill(Theme.Colors.accentCyan.opacity(0.9)))
                                    .padding(24)
                            }
                        }
                    }
                }
                .padding(.horizontal, Theme.Layout.horizontalPadding)
                .padding(.top, 8)
                .padding(.bottom, 100)
            }
        }
        .onAppear { viewModel.load() }
    }
}

#Preview {
    MeetupsView()
}
