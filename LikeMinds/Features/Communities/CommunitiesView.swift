import SwiftUI

struct CommunitiesView: View {
    @StateObject private var viewModel = CommunitiesViewModel()

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    var body: some View {
        NavigationStack {
            ScreenShell {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Communities")
                            .font(Theme.Typography.display(30))
                            .foregroundStyle(.white)
                        Text("Find circles that match your hobbies and vibe.")
                            .font(Theme.Typography.body(15))
                            .foregroundStyle(Theme.Colors.textSecondary)

                        LazyVGrid(columns: columns, spacing: 14) {
                            ForEach(viewModel.communities) { community in
                                NavigationLink(value: community) {
                                    CommunityCategoryCard(community: community)
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal, Theme.Layout.horizontalPadding)
                    .padding(.top, 8)
                    .padding(.bottom, 100)
                }
            }
            .navigationDestination(for: LMCommunity.self) { community in
                CommunityDetailView(community: community)
            }
        }
        .onAppear { viewModel.load() }
    }
}

#Preview {
    CommunitiesView()
}
