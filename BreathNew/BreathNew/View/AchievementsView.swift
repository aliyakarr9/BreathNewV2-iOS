import SwiftUI

struct AchievementsView: View {
    @StateObject private var viewModel = AchievementsViewModel()
    @EnvironmentObject var languageManager: LanguageManager

    let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(viewModel.badges) { badge in
                        BadgeView(badge: badge)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .navigationTitle("Achievements")
            .background(Color.appBackground)
            .onAppear {
                viewModel.updateBadges()
            }
        }
        .id(languageManager.selectedLanguage)
    }
}

struct BadgeView: View {
    let badge: Badge

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: badge.iconName)
                .resizable()
                .scaledToFit()
                .frame(height: 44)
                .foregroundStyle(badge.isUnlocked ? Color.badgeGold : Color.primary.opacity(0.18))

            Text(LocalizedStringKey(badge.title))
                .font(.footnote.weight(.semibold))
                .foregroundStyle(badge.isUnlocked ? .primary : .secondary)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(height: 84)
        .card(padding: 16)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(badge.isUnlocked ? .isSelected : [])
    }
}
