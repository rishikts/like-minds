import SwiftUI

struct DiscoverPeopleView: View {
    @StateObject private var viewModel = DiscoverPeopleViewModel()

    var body: some View {
        ScreenShell {
            VStack(spacing: 20) {
                VStack(spacing: 6) {
                    Text("Discover")
                        .font(Theme.Typography.display(30))
                        .foregroundStyle(.white)
                    Text("Same vibe. New friends.")
                        .font(Theme.Typography.body(15))
                        .foregroundStyle(Theme.Colors.textSecondary)
                }
                .padding(.top, 8)

                if let person = viewModel.currentPerson {
                    DiscoverPersonCard(person: person) {
                        viewModel.next()
                    }
                    .padding(.horizontal, Theme.Layout.horizontalPadding)
                    .id(person.id)
                    .transition(.asymmetric(insertion: .scale.combined(with: .opacity), removal: .opacity))

                    HStack(spacing: 40) {
                        circleButton(symbol: "arrow.left") { viewModel.previous() }
                        circleButton(symbol: "heart.fill", accent: true) { viewModel.next() }
                        circleButton(symbol: "arrow.right") { viewModel.next() }
                    }
                }

                Spacer(minLength: 0)
            }
            .padding(.bottom, 100)
        }
        .onAppear { viewModel.load() }
    }

    private func circleButton(symbol: String, accent: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(
                    Circle().fill(accent ? AnyShapeStyle(Theme.Colors.buttonGradient) : AnyShapeStyle(Theme.Colors.glassFill))
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    DiscoverPeopleView()
}
