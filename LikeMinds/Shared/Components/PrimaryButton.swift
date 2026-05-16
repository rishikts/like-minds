import SwiftUI

struct PrimaryButton: View {
    let title: String
    var isEnabled: Bool = true
    let action: () -> Void

    @State private var isPressed = false
    @State private var shimmerPhase: CGFloat = -1

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: Theme.Layout.cornerRadiusPill, style: .continuous)
                    .fill(Theme.Colors.buttonGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Layout.cornerRadiusPill, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(0.35),
                                        .clear,
                                        .white.opacity(0.12)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    )

                RoundedRectangle(cornerRadius: Theme.Layout.cornerRadiusPill, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [.clear, .white.opacity(0.45), .clear],
                            startPoint: UnitPoint(x: shimmerPhase, y: 0.5),
                            endPoint: UnitPoint(x: shimmerPhase + 0.35, y: 0.5)
                        )
                    )
                    .blendMode(.overlay)
                    .allowsHitTesting(false)

                Text(title)
                    .font(Theme.Typography.button())
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .shadow(color: Theme.Colors.accentCoral.opacity(0.45), radius: isPressed ? 8 : 20, y: isPressed ? 4 : 10)
            .scaleEffect(isPressed ? 0.97 : 1)
            .opacity(isEnabled ? 1 : 0.5)
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(Theme.Layout.springBouncy) { isPressed = true }
                }
                .onEnded { _ in
                    withAnimation(Theme.Layout.springBouncy) { isPressed = false }
                }
        )
        .onAppear {
            withAnimation(.linear(duration: 2.8).repeatForever(autoreverses: false)) {
                shimmerPhase = 1.4
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        PrimaryButton(title: "Get Started") {}
            .padding()
    }
}
