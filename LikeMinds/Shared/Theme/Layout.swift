import SwiftUI

extension Theme {
    enum Layout {
        static let horizontalPadding: CGFloat = 28
        static let sectionSpacing: CGFloat = 32
        static let cornerRadiusLarge: CGFloat = 28
        static let cornerRadiusMedium: CGFloat = 20
        static let cornerRadiusPill: CGFloat = 999

        static let springSmooth = Animation.spring(response: 0.62, dampingFraction: 0.82)
        static let springBouncy = Animation.spring(response: 0.48, dampingFraction: 0.72)
        static let easeOutLong = Animation.easeOut(duration: 0.9)
    }
}
