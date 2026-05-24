import SwiftUI

@MainActor
final class NotificationsViewModel: ObservableObject {
    @Published private(set) var items: [LMNotificationItem] = []

    func load() {
        items = MockData.notifications
    }

    func markAllRead() {
        items = items.map { var n = $0; n.isUnread = false; return n }
    }
}
