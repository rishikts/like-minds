import SwiftUI

@MainActor
final class MeetupsViewModel: ObservableObject {
    @Published private(set) var meetups: [LMMeetup] = []
    @Published var rsvpIDs: Set<String> = []

    func load() {
        meetups = MockData.meetups
    }

    func toggleRSVP(_ id: String) {
        if rsvpIDs.contains(id) { rsvpIDs.remove(id) } else { rsvpIDs.insert(id) }
    }
}
