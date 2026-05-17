import Foundation

enum LMNotificationKind: String, Hashable {
    case meetupReminder
    case joinRequest
    case communityActivity
    case recommendation
    case friendActivity
}

struct LMNotificationItem: Identifiable, Hashable {
    let id: String
    let kind: LMNotificationKind
    let title: String
    let body: String
    let timeAgo: String
    let iconName: String
    var isUnread: Bool
}
