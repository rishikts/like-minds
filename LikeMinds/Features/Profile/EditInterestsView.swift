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
                VStack(alignment: .leading, spacing: 32) {
                    Text("Edit interests & vibe")
                        .font(Theme.Typography.display(26))
                        .foregroundStyle(.white)
                        .padding(.bottom, 4)

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

                    VStack(alignment: .leading, spacing: 16) {
                        SectionHeaderView(title: "Social comfort")
                        VStack(spacing: 12) {
                            ForEach(viewModel.comfortLevels, id: \.self) { level in
                                OnboardingCardOption(
                                    title: level,
                                    subtitle: comfortSubtitle(for: level),
                                    symbolName: comfortSymbol(for: level),
                                    isSelected: viewModel.socialComfort == level
                                ) {
                                    viewModel.socialComfort = level
                                }
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 16) {
                        SectionHeaderView(title: "Bio")
                        OnboardingMultilineField(
                            placeholder: "Tell people about you…",
                            text: $viewModel.draftBio,
                            characterLimit: 200
                        )
                    }
                }
                .padding(.horizontal, Theme.Layout.horizontalPadding)
                .padding(.top, 8)
                .padding(.bottom, 120)
            }
        }
        .safeAreaInset(edge: .bottom) {
            PrimaryButton(title: "Save") {
                viewModel.save()
                dismiss()
            }
            .padding(.horizontal, Theme.Layout.horizontalPadding)
            .padding(.top, 12)
            .padding(.bottom, 12)
            .background {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea(edges: .bottom)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func chipSection(title: String, options: [String], chip: @escaping (String) -> SelectableChip) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeaderView(title: title)
            FlowLayout(spacing: 10) {
                ForEach(options, id: \.self) { option in
                    chip(option)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func comfortSubtitle(for level: String) -> String {
        switch level {
        case "Introvert": "Quiet, intimate settings"
        case "Balanced": "Mix of cozy and social"
        case "Extrovert": "Lively groups often"
        default: ""
        }
    }

    private func comfortSymbol(for level: String) -> String {
        switch level {
        case "Introvert": "moon.stars.fill"
        case "Balanced": "scalemass.fill"
        case "Extrovert": "sparkles"
        default: "person.fill"
        }
    }
}

#Preview {
    NavigationStack {
        EditInterestsView(profile: MockData.currentUser)
    }
}
