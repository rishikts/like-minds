import Foundation

enum MockData {
    static let currentUser = LMUserProfile(
        name: "Rishi",
        username: "rishi_explores",
        bio: "Weekend trekker, café hopper, and startup nerd. Always down for thoughtful conversations.",
        city: "Bangalore",
        interests: ["Trekking", "Café Hopping", "Startups", "Photography", "Anime"],
        vibeTags: ["Adventurer", "Thinker", "Connector"],
        socialComfort: "Balanced",
        meetupsAttended: 12,
        meetupsHosted: 3,
        badges: ["Early Explorer", "Community Builder", "Vibe Matcher"],
        favoriteCommunities: ["Sunset Trekkers", "Book & Brew", "Startup Circle"],
        avatarSymbol: "person.crop.circle.fill"
    )

    static let communities: [LMCommunity] = [
        LMCommunity(id: "trek", name: "Sunset Trekkers", category: "Trekking", description: "Weekend trails, sunrise hikes, and mindful miles with kindred explorers.", memberCount: 2840, vibeTags: ["Adventurer", "Outdoors"], iconName: "figure.hiking", gradientColors: ["violet", "coral"], upcomingMeetupCount: 4),
        LMCommunity(id: "read", name: "Book & Brew", category: "Reading", description: "Cozy reads, poetry nights, and café conversations that go deep.", memberCount: 1920, vibeTags: ["Thinker", "Café"], iconName: "book.fill", gradientColors: ["cyan", "violet"], upcomingMeetupCount: 2),
        LMCommunity(id: "cricket", name: "Weekend XI", category: "Cricket", description: "Pick-up games, screening nights, and banter-filled Sundays.", memberCount: 4100, vibeTags: ["Sports", "Social"], iconName: "sportscourt.fill", gradientColors: ["gold", "coral"], upcomingMeetupCount: 3),
        LMCommunity(id: "food", name: "Hidden Bites", category: "Food", description: "Street food crawls and chef-table discoveries across the city.", memberCount: 3560, vibeTags: ["Foodie", "Explorer"], iconName: "fork.knife", gradientColors: ["coral", "violet"], upcomingMeetupCount: 5),
        LMCommunity(id: "art", name: "Canvas Collective", category: "Art", description: "Sketch jams, gallery walks, and creative collabs.", memberCount: 980, vibeTags: ["Creator"], iconName: "paintpalette.fill", gradientColors: ["violet", "cyan"], upcomingMeetupCount: 1),
        LMCommunity(id: "music", name: "Lo-Fi Lounge", category: "Music", description: "Listening parties, open mics, and vinyl nights.", memberCount: 2210, vibeTags: ["Creator", "Chill"], iconName: "music.note", gradientColors: ["cyan", "gold"], upcomingMeetupCount: 2),
        LMCommunity(id: "anime", name: "Otaku Orbit", category: "Anime", description: "Watch parties, cosplay cafés, and manga swaps.", memberCount: 1680, vibeTags: ["Anime", "Social"], iconName: "tv.fill", gradientColors: ["violet", "gold"], upcomingMeetupCount: 2),
        LMCommunity(id: "run", name: "Dawn Run Club", category: "Running", description: "5K mornings, river runs, and post-run smoothies.", memberCount: 1340, vibeTags: ["Adventurer"], iconName: "figure.run", gradientColors: ["coral", "cyan"], upcomingMeetupCount: 3),
        LMCommunity(id: "startup", name: "Startup Circle", category: "Startups", description: "Founder coffees, pitch practice, and builder energy.", memberCount: 2450, vibeTags: ["Thinker", "Builder"], iconName: "lightbulb.fill", gradientColors: ["gold", "violet"], upcomingMeetupCount: 4),
        LMCommunity(id: "photo", name: "Frame Hunters", category: "Photography", description: "Golden-hour shoots and cityscape walks.", memberCount: 1120, vibeTags: ["Creator"], iconName: "camera.fill", gradientColors: ["cyan", "coral"], upcomingMeetupCount: 1)
    ]

    static let meetups: [LMMeetup] = [
        LMMeetup(id: "m1", title: "Sunset Trek — Nandi Hills", communityName: "Sunset Trekkers", location: "Nandi Hills, Bangalore", date: .now.addingTimeInterval(86400 * 2), attendeeCount: 18, maxAttendees: 24, vibeTags: ["Adventurer", "Outdoors"], imageSymbol: "sun.horizon.fill", isTrending: true),
        LMMeetup(id: "m2", title: "Anime Café Meetup", communityName: "Otaku Orbit", location: "Koramangala", date: .now.addingTimeInterval(86400 * 4), attendeeCount: 12, maxAttendees: 16, vibeTags: ["Anime", "Social"], imageSymbol: "cup.and.saucer.fill", isTrending: true),
        LMMeetup(id: "m3", title: "Cricket Screening Night", communityName: "Weekend XI", location: "Indiranagar", date: .now.addingTimeInterval(86400 * 1), attendeeCount: 32, maxAttendees: 40, vibeTags: ["Sports"], imageSymbol: "sportscourt.fill", isTrending: false),
        LMMeetup(id: "m4", title: "Book Club Evening", communityName: "Book & Brew", location: "Jayanagar", date: .now.addingTimeInterval(86400 * 6), attendeeCount: 9, maxAttendees: 14, vibeTags: ["Thinker", "Café"], imageSymbol: "book.fill", isTrending: false),
        LMMeetup(id: "m5", title: "Founder Coffee & Ideas", communityName: "Startup Circle", location: "HSR Layout", date: .now.addingTimeInterval(86400 * 3), attendeeCount: 15, maxAttendees: 20, vibeTags: ["Builder"], imageSymbol: "lightbulb.fill", isTrending: true),
        LMMeetup(id: "m6", title: "Street Food Crawl", communityName: "Hidden Bites", location: "VV Puram", date: .now.addingTimeInterval(86400 * 5), attendeeCount: 22, maxAttendees: 25, vibeTags: ["Foodie"], imageSymbol: "fork.knife", isTrending: false)
    ]

    static let discoverPeople: [LMDiscoverPerson] = [
        LMDiscoverPerson(id: "p1", name: "Aanya", age: 24, city: "Bangalore", bio: "Trekker · reader · loves deep café chats", interests: ["Trekking", "Reading", "Café"], vibeTags: ["Adventurer", "Thinker"], mutualCount: 4, matchScore: 92, avatarSymbol: "person.fill"),
        LMDiscoverPerson(id: "p2", name: "Kabir", age: 26, city: "Bangalore", bio: "Cricket weekends, startup ideas, good banter", interests: ["Cricket", "Startups"], vibeTags: ["Connector", "Builder"], mutualCount: 3, matchScore: 88, avatarSymbol: "person.fill"),
        LMDiscoverPerson(id: "p3", name: "Mira", age: 23, city: "Bangalore", bio: "Anime, art, and cozy bookstores", interests: ["Anime", "Art", "Reading"], vibeTags: ["Creator", "Thinker"], mutualCount: 5, matchScore: 95, avatarSymbol: "person.fill"),
        LMDiscoverPerson(id: "p4", name: "Arjun", age: 25, city: "Bangalore", bio: "Runner · photographer · always exploring", interests: ["Running", "Photography"], vibeTags: ["Adventurer", "Creator"], mutualCount: 2, matchScore: 84, avatarSymbol: "person.fill")
    ]

    static let feedActivity: [LMFeedActivity] = [
        LMFeedActivity(id: "a1", userName: "Mira", action: "joined", communityName: "Otaku Orbit", timeAgo: "2h", avatarSymbol: "person.fill"),
        LMFeedActivity(id: "a2", userName: "Kabir", action: "RSVP'd to", communityName: "Cricket Screening Night", timeAgo: "4h", avatarSymbol: "person.fill"),
        LMFeedActivity(id: "a3", userName: "Aanya", action: "hosted", communityName: "Sunset Trek", timeAgo: "1d", avatarSymbol: "person.fill")
    ]

    static let recommendations: [LMFeedRecommendation] = [
        LMFeedRecommendation(id: "r1", title: "Your vibe tribe is growing", subtitle: "3 new people match your interests this week", cta: "Discover", iconName: "sparkles"),
        LMFeedRecommendation(id: "r2", title: "Perfect weekend trek", subtitle: "Based on trekking + outdoors", cta: "View meetup", iconName: "map.fill")
    ]

    static let notifications: [LMNotificationItem] = [
        LMNotificationItem(id: "n1", kind: .meetupReminder, title: "Sunset Trek tomorrow", body: "Nandi Hills · 5:30 AM — don't forget water!", timeAgo: "1h", iconName: "calendar", isUnread: true),
        LMNotificationItem(id: "n2", kind: .joinRequest, title: "Join request", body: "Priya wants to join Book & Brew", timeAgo: "3h", iconName: "person.badge.plus", isUnread: true),
        LMNotificationItem(id: "n3", kind: .communityActivity, title: "New post in Startup Circle", body: "Founder coffee this Saturday — 12 going", timeAgo: "5h", iconName: "bubble.left.and.bubble.right.fill", isUnread: false),
        LMNotificationItem(id: "n4", kind: .recommendation, title: "Meetup for you", body: "Anime Café Meetup matches your vibes", timeAgo: "1d", iconName: "star.fill", isUnread: false),
        LMNotificationItem(id: "n5", kind: .friendActivity, title: "Aanya joined a trek", body: "Sunset Trekkers · you might know people going", timeAgo: "1d", iconName: "person.2.fill", isUnread: false)
    ]

    static func community(id: String) -> LMCommunity? {
        communities.first { $0.id == id }
    }
}
