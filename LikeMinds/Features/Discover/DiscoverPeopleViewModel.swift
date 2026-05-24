import SwiftUI

@MainActor
final class DiscoverPeopleViewModel: ObservableObject {
    @Published private(set) var people: [LMDiscoverPerson] = []
    @Published var currentIndex = 0

    func load() {
        people = MockData.discoverPeople
    }

    var currentPerson: LMDiscoverPerson? {
        guard people.indices.contains(currentIndex) else { return nil }
        return people[currentIndex]
    }

    func next() {
        guard !people.isEmpty else { return }
        withAnimation(Theme.Layout.springSmooth) {
            currentIndex = (currentIndex + 1) % people.count
        }
    }

    func previous() {
        guard !people.isEmpty else { return }
        withAnimation(Theme.Layout.springSmooth) {
            currentIndex = (currentIndex - 1 + people.count) % people.count
        }
    }
}
