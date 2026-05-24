import SwiftUI

struct AuthProviderButton: View {
    enum Style {
        case filled
        case glass
        case subtle
    }

    let title: String
    let symbolName: String
    var style: Style = .glass
    var isLoading: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                        .frame(width: 22, height: 22)
                } else {
                    Image(systemName: symbolName)
                        .font(.system(size: 18, weight: .semibold))
                        .frame(width: 22)
                }

                Text(title)
                    .font(Theme.Typography.button())
                    .lineLimit(1)

                Spacer(minLength: 0)
            }
            .foregroundStyle(foregroundColor)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background { background }
        }
        .buttonStyle(.plain)
        .disabled(isLoading)
        .opacity(isLoading ? 0.85 : 1)
    }

    private var foregroundColor: Color {
        switch style {
        case .filled: .white
        case .glass, .subtle: Theme.Colors.textPrimary
        }
    }

    @ViewBuilder
    private var background: some View {
        switch style {
        case .filled:
            RoundedRectangle(cornerRadius: Theme.Layout.cornerRadiusPill, style: .continuous)
                .fill(Theme.Colors.buttonGradient)
        case .glass:
            RoundedRectangle(cornerRadius: Theme.Layout.cornerRadiusPill, style: .continuous)
                .fill(.ultraThinMaterial)
                .background(
                    RoundedRectangle(cornerRadius: Theme.Layout.cornerRadiusPill, style: .continuous)
                        .fill(Theme.Colors.glassFill)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Layout.cornerRadiusPill, style: .continuous)
                        .stroke(Theme.Colors.glassStroke.opacity(0.45), lineWidth: 1)
                )
        case .subtle:
            RoundedRectangle(cornerRadius: Theme.Layout.cornerRadiusPill, style: .continuous)
                .stroke(Theme.Colors.glassStroke.opacity(0.35), lineWidth: 1)
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VStack(spacing: 12) {
            AuthProviderButton(title: "Continue with Apple", symbolName: "apple.logo", style: .filled) {}
            AuthProviderButton(title: "Continue with Google", symbolName: "g.circle.fill") {}
        }
        .padding()
    }
}
