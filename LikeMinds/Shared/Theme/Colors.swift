import SwiftUI

enum Theme {}

extension Theme {
    enum Colors {
        static let canvasTop = Color(red: 0.06, green: 0.04, blue: 0.14)
        static let canvasBottom = Color(red: 0.02, green: 0.02, blue: 0.06)

        static let accentCoral = Color(red: 1.0, green: 0.42, blue: 0.55)
        static let accentViolet = Color(red: 0.58, green: 0.38, blue: 1.0)
        static let accentCyan = Color(red: 0.35, green: 0.88, blue: 0.95)
        static let accentGold = Color(red: 1.0, green: 0.78, blue: 0.45)

        static let textPrimary = Color.white
        static let textSecondary = Color.white.opacity(0.72)
        static let textTertiary = Color.white.opacity(0.48)

        static let glassFill = Color.white.opacity(0.08)
        static let glassStroke = Color.white.opacity(0.22)
        static let glassHighlight = Color.white.opacity(0.35)

        static var heroGradient: LinearGradient {
            LinearGradient(
                colors: [accentViolet, accentCoral, accentCyan.opacity(0.85)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }

        static var buttonGradient: LinearGradient {
            LinearGradient(
                colors: [
                    accentCoral,
                    Color(red: 0.92, green: 0.35, blue: 0.72),
                    accentViolet
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        }

        static var ambientGlow: RadialGradient {
            RadialGradient(
                colors: [accentViolet.opacity(0.55), .clear],
                center: .center,
                startRadius: 20,
                endRadius: 220
            )
        }

        static func named(_ key: String) -> Color? {
            switch key {
            case "violet": accentViolet
            case "coral": accentCoral
            case "cyan": accentCyan
            case "gold": accentGold
            default: nil
            }
        }
    }
}
