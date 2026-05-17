import PhotosUI
import SwiftUI

struct OnboardingStepContent: View {
    @ObservedObject var viewModel: OnboardingViewModel
    let step: OnboardingStep

    @State private var photoItem: PhotosPickerItem?

    var body: some View {
        Group {
            switch step {
            case .fullName: fullNameStep
            case .username: usernameStep
            case .profilePhoto: profilePhotoStep
            case .dateOfBirth: dateOfBirthStep
            case .gender: genderStep
            case .city: cityStep
            case .occupation: occupationStep
            case .bio: bioStep
            case .personality: personalityStep
            case .socialComfort: socialComfortStep
            case .interests: interestsStep
            case .hobbies: hobbiesStep
            }
        }
    }

    // MARK: - Steps

    private var fullNameStep: some View {
        OnboardingTextField(
            placeholder: "Full name",
            text: $viewModel.profile.fullName,
            textContentType: .name,
            autocapitalization: .words
        )
    }

    private var usernameStep: some View {
        VStack(alignment: .leading, spacing: 10) {
            OnboardingTextField(
                placeholder: "username",
                text: $viewModel.profile.username,
                textContentType: .username,
                autocapitalization: .never
            )
            Text(viewModel.profile.isUsernameValid ? "Looks great!" : "3–24 characters · letters, numbers, _ .")
                .font(Theme.Typography.caption(12))
                .foregroundStyle(
                    viewModel.profile.isUsernameValid ? Theme.Colors.accentCyan : Theme.Colors.textTertiary
                )
        }
    }

    private var profilePhotoStep: some View {
        VStack(spacing: 20) {
            ZStack {
                if let data = viewModel.profile.profilePhotoData,
                   let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 56))
                        .foregroundStyle(Theme.Colors.textTertiary)
                }
            }
            .frame(width: 140, height: 140)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Theme.Colors.heroGradient, lineWidth: 3)
            )
            .shadow(color: Theme.Colors.accentViolet.opacity(0.35), radius: 24, y: 10)

            PhotosPicker(selection: $photoItem, matching: .images) {
                Text("Choose photo")
                    .font(Theme.Typography.button())
                    .foregroundStyle(Theme.Colors.accentCyan)
            }
            .onChange(of: photoItem) { _, item in
                Task {
                    if let data = try? await item?.loadTransferable(type: Data.self) {
                        viewModel.profile.profilePhotoData = data
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var dateOfBirthStep: some View {
        DatePicker(
            "Birthday",
            selection: Binding(
                get: { viewModel.profile.dateOfBirth ?? Calendar.current.date(byAdding: .year, value: -22, to: .now)! },
                set: { viewModel.profile.dateOfBirth = $0 }
            ),
            in: ...Date(),
            displayedComponents: .date
        )
        .datePickerStyle(.wheel)
        .labelsHidden()
        .colorScheme(.dark)
        .frame(maxWidth: .infinity)
    }

    private var genderStep: some View {
        VStack(spacing: 12) {
            ForEach(["Woman", "Man", "Non-binary", "Prefer not to say"], id: \.self) { option in
                OnboardingCardOption(
                    title: option,
                    subtitle: option == "Prefer not to say" ? "We'll keep this private" : " ",
                    symbolName: "person.fill",
                    isSelected: viewModel.profile.gender == option
                ) {
                    viewModel.profile.gender = option
                }
            }
        }
    }

    private var cityStep: some View {
        OnboardingTextField(
            placeholder: "City or neighborhood",
            text: $viewModel.profile.city,
            textContentType: .addressCity
        )
    }

    private var occupationStep: some View {
        VStack(spacing: 12) {
            ForEach(occupationOptions, id: \.title) { option in
                OnboardingCardOption(
                    title: option.title,
                    subtitle: option.subtitle,
                    symbolName: option.symbol,
                    isSelected: viewModel.profile.occupationStatus == option.title
                ) {
                    viewModel.profile.occupationStatus = option.title
                }
            }
        }
    }

    private var bioStep: some View {
        OnboardingMultilineField(
            placeholder: "What should people know about you?",
            text: $viewModel.profile.bio,
            characterLimit: 200
        )
    }

    private var personalityStep: some View {
        FlowLayout(spacing: 10) {
            ForEach(personalityOptions, id: \.title) { option in
                SelectableChip(
                    title: option.title,
                    symbolName: option.symbol,
                    isSelected: viewModel.profile.personalityTypes.contains(option.title)
                ) {
                    viewModel.togglePersonalityVibe(option.title)
                }
            }
        }
    }

    private var socialComfortStep: some View {
        VStack(spacing: 12) {
            ForEach(SocialComfortLevel.allCases) { level in
                OnboardingCardOption(
                    title: level.title,
                    subtitle: level.subtitle,
                    symbolName: level.symbolName,
                    isSelected: viewModel.profile.socialComfort == level
                ) {
                    viewModel.profile.socialComfort = level
                }
            }
        }
    }

    private var interestsStep: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {
                ForEach(InterestCatalog.categories) { category in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(category.title)
                            .font(Theme.Typography.title(18))
                            .foregroundStyle(Theme.Colors.textPrimary)

                        FlowLayout(spacing: 10) {
                            ForEach(category.items) { item in
                                SelectableChip(
                                    title: item.title,
                                    symbolName: item.symbolName,
                                    isSelected: viewModel.profile.selectedInterestIDs.contains(item.id)
                                ) {
                                    viewModel.toggleInterest(item.id)
                                }
                            }
                        }
                    }
                }
            }
        }
        .frame(maxHeight: 360)
    }

    private var hobbiesStep: some View {
        OnboardingMultilineField(
            placeholder: "I love peaceful cafés, weekend treks, books about psychology, and meeting thoughtful people.",
            text: $viewModel.profile.hobbiesNarrative,
            characterLimit: 280
        )
    }

    // MARK: - Data

    private var occupationOptions: [(title: String, subtitle: String, symbol: String)] {
        [
            ("Student", "Learning, growing, exploring", "graduationcap.fill"),
            ("Working Professional", "Building my career", "briefcase.fill"),
            ("Founder / Builder", "Creating something new", "hammer.fill"),
            ("Freelancer / Creative", "Projects on my own terms", "paintbrush.fill"),
            ("Exploring", "Figuring out what's next", "compass.drawing")
        ]
    }

    private var personalityOptions: [(title: String, subtitle: String, symbol: String)] {
        [
            ("Adventurer", "Curious, spontaneous, outdoorsy", "map.fill"),
            ("Thinker", "Deep conversations, ideas, books", "brain.head.profile"),
            ("Connector", "Brings people together", "person.3.fill"),
            ("Creator", "Makes, designs, expresses", "sparkles"),
            ("Balancer", "A bit of everything", "circle.hexagongrid.fill")
        ]
    }
}

// MARK: - Flow layout for chips

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y),
                proposal: .unspecified
            )
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }

        return (CGSize(width: maxWidth, height: y + rowHeight), positions)
    }
}
