import SwiftUI

struct NotificationsView: View {
    @StateObject private var viewModel = NotificationsViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScreenShell(showOrbs: false) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(viewModel.items) { item in
                            NotificationRow(item: item)
                            Divider().overlay(Theme.Colors.glassStroke.opacity(0.3))
                        }
                    }
                    .padding(.horizontal, Theme.Layout.horizontalPadding)
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                        .foregroundStyle(Theme.Colors.textSecondary)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Mark all read") { viewModel.markAllRead() }
                        .font(Theme.Typography.caption(13))
                        .foregroundStyle(Theme.Colors.accentCyan)
                }
            }
        }
        .onAppear { viewModel.load() }
    }
}

#Preview {
    NotificationsView()
}
