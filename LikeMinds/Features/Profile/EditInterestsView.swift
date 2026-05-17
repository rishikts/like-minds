import SwiftUI

struct EditInterestsView: View {
    @StateObject private var viewModel: EditInterestsViewModel
    @Environment(\.dismiss) private var dismiss

    init(profile: LMUserProfile) {
        _viewModel = StateObject(wrappedValue: EditInterestsViewModel(profile: profile))
    }

    var body: some View {
        ScreenShell(showOrbs: false) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 28) {
                    Text("Edit interests & vibe")
                        .font(Theme.Typography.display(26))
                        .foregroundStyle(.white)

                    chipSection(title: "Personality vibe", options: viewModel.vibeOptions) { vibe in
                        SelectableChip(title: vibe, isSelected: viewModel.selectedVibes.contains(vibe)) {
                            viewModel.toggleVibe(vibe)
                        }
                    }

                    chipSection(title: "Interests", options: viewModel.interestOptions) { interest in
                        SelectableChip(title: interest, isSelected: viewModel.selectedInterests.contains(interest)) {
                            viewModel.toggleInterest(interest)
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeaderView(title: "Social comfort")
                        ForEach(viewModel.comfortLevels, id: \.self) { level in
                            OnboardingCardOption(
                                title: level,
                                subtitle: " ",
                                symbolName: "person.fill",
                                isSelected: viewModel.socialComfort == level
                            ) {
                                viewModel.socialComfort = level
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeaderView(title: "Bio")
                        OnboardingMultilineField(
                            placeholder: "Tell people about you…",
                            text: $viewModel.draftBio,
                            characterLimit: 200
                        )
                    }
                }
                .padding(.horizontal, Theme.Layout.horizontalPadding)
                .padding(.bottom, 100)
            }
        }
        .safeAreaInset(edge: .bottom) {
            PrimaryButton(title: "Save") {
                viewModel.save()
                dismiss()
            }
            .padding(.horizontal, Theme.Layout.horizontalPadding)
            .padding(.bottom, 12)
            .background(.ultraThinMaterial)
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func chipSection(title: String, options: [String], chip: @escaping (String) -> SelectableChip) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeaderView(title: title)
            FlowLayout(spacing: 10) {
                ForEach(options, id: \.self) { option in
                    chip(option)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        EditInterestsView(profile: MockData.currentUser)
    }
}
