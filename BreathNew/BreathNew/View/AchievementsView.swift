import SwiftUI

struct AchievementsView: View {
    @StateObject private var viewModel = AchievementsViewModel()

    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.badges) { badge in
                        BadgeView(badge: badge)
                    }
                }
                .padding()
            }
            // Başlık zaten otomatik çevrilir ama garanti olsun
            .navigationTitle("Achievements")
            .onAppear {
                viewModel.updateBadges()
            }
        }
    }
}

struct BadgeView: View {
    let badge: Badge

    var body: some View {
        VStack {
            Image(systemName: badge.iconName)
                .resizable()
                .scaledToFit()
                .frame(height: 50)
                .foregroundColor(badge.isUnlocked ? .yellow : .gray)

            // DÜZELTME: badge.title'ı LocalizedStringKey içine aldık
            Text(LocalizedStringKey(badge.title))
                .font(.caption)
                .bold()
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(width: 100, height: 120)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .opacity(badge.isUnlocked ? 1.0 : 0.6)
    }
}
