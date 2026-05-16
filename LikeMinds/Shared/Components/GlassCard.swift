import SwiftUI

struct GlassCard<Content: View>: View {
    var cornerRadius: CGFloat = Theme.Layout.cornerRadiusLarge
    var content: () -> Content

    var body: some View {
        content()
            .background {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .background(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(Theme.Colors.glassFill)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Theme.Colors.glassHighlight,
                                        Theme.Colors.glassStroke.opacity(0.35),
                                        Theme.Colors.glassStroke.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: Theme.Colors.accentViolet.opacity(0.15), radius: 24, y: 12)
            }
    }
}

#Preview {
    GlassCard {
        Text("Glass")
            .foregroundStyle(.white)
            .padding(32)
    }
    .padding()
    .background(Color.black)
}
