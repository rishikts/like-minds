import SwiftUI

extension Theme {
    enum Typography {
        static func display(_ size: CGFloat = 38) -> Font {
            .system(size: size, weight: .bold, design: .rounded)
        }

        static func title(_ size: CGFloat = 22) -> Font {
            .system(size: size, weight: .semibold, design: .rounded)
        }

        static func body(_ size: CGFloat = 17) -> Font {
            .system(size: size, weight: .regular, design: .rounded)
        }

        static func caption(_ size: CGFloat = 15) -> Font {
            .system(size: size, weight: .medium, design: .rounded)
        }

        static func button() -> Font {
            .system(size: 17, weight: .semibold, design: .rounded)
        }
    }
}
