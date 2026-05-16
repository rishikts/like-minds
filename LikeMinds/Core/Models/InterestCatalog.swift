import Foundation

struct InterestItem: Identifiable, Hashable, Sendable {
    let id: String
    let title: String
    let symbolName: String
}

struct InterestCategory: Identifiable, Sendable {
    let id: String
    let title: String
    let items: [InterestItem]
}

enum InterestCatalog {
    static let categories: [InterestCategory] = [
        InterestCategory(
            id: "outdoor",
            title: "Outdoor",
            items: [
                InterestItem(id: "trekking", title: "Trekking", symbolName: "figure.hiking"),
                InterestItem(id: "hiking", title: "Hiking", symbolName: "mountain.2.fill"),
                InterestItem(id: "running", title: "Running", symbolName: "figure.run"),
                InterestItem(id: "cycling", title: "Cycling", symbolName: "bicycle"),
                InterestItem(id: "camping", title: "Camping", symbolName: "tent.fill"),
                InterestItem(id: "travel", title: "Travel", symbolName: "airplane")
            ]
        ),
        InterestCategory(
            id: "sports",
            title: "Sports",
            items: [
                InterestItem(id: "cricket", title: "Cricket", symbolName: "sportscourt.fill"),
                InterestItem(id: "football", title: "Football", symbolName: "soccerball"),
                InterestItem(id: "badminton", title: "Badminton", symbolName: "figure.badminton"),
                InterestItem(id: "pool", title: "Pool", symbolName: "circle.grid.cross.fill"),
                InterestItem(id: "chess", title: "Chess", symbolName: "checkerboard.rectangle"),
                InterestItem(id: "pickleball", title: "Pickleball", symbolName: "figure.tennis")
            ]
        ),
        InterestCategory(
            id: "creative",
            title: "Creative",
            items: [
                InterestItem(id: "reading", title: "Reading", symbolName: "book.fill"),
                InterestItem(id: "art", title: "Art", symbolName: "paintpalette.fill"),
                InterestItem(id: "photography", title: "Photography", symbolName: "camera.fill"),
                InterestItem(id: "music", title: "Music", symbolName: "music.note"),
                InterestItem(id: "poetry", title: "Poetry", symbolName: "text.quote"),
                InterestItem(id: "anime", title: "Anime", symbolName: "tv.fill")
            ]
        ),
        InterestCategory(
            id: "food",
            title: "Food & Lifestyle",
            items: [
                InterestItem(id: "cafe", title: "Café Hopping", symbolName: "cup.and.saucer.fill"),
                InterestItem(id: "food", title: "Food Exploration", symbolName: "fork.knife"),
                InterestItem(id: "cooking", title: "Cooking", symbolName: "frying.pan.fill"),
                InterestItem(id: "wellness", title: "Wellness", symbolName: "leaf.fill"),
                InterestItem(id: "yoga", title: "Yoga", symbolName: "figure.yoga")
            ]
        ),
        InterestCategory(
            id: "growth",
            title: "Growth",
            items: [
                InterestItem(id: "startups", title: "Startups", symbolName: "lightbulb.fill"),
                InterestItem(id: "ai", title: "AI", symbolName: "brain.head.profile"),
                InterestItem(id: "investing", title: "Investing", symbolName: "chart.line.uptrend.xyaxis"),
                InterestItem(id: "coding", title: "Coding", symbolName: "chevron.left.forwardslash.chevron.right"),
                InterestItem(id: "speaking", title: "Public Speaking", symbolName: "mic.fill")
            ]
        )
    ]

    static var allItemIDs: Set<String> {
        Set(categories.flatMap { $0.items.map(\.id) })
    }
}
