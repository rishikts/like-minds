import SwiftUI

struct SectionHeaderView: View {
    let title: String
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(Theme.Typography.title(20))
                .foregroundStyle(Theme.Colors.textPrimary)
            Spacer()
            if let actionTitle, let action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(Theme.Typography.caption(14))
                        .foregroundStyle(Theme.Colors.accentCyan)
                }
            }
        }
    }
}

#Preview {
    SectionHeaderView(title: "Trending meetups", actionTitle: "See all") {}
        .padding()
        .background(Color.black)
}
