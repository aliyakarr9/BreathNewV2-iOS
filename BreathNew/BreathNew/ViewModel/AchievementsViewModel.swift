import Foundation
import SwiftUI
import Combine

class AchievementsViewModel: ObservableObject {
    @Published var badges: [Badge] = []

    init() {
        setupBadges()
        updateBadges()
    }

    func setupBadges() {
        self.badges = Badge.all
    }

    func updateBadges() {
        let quitDate = DataManager.shared.userData.quitDate
        let elapsed = Date().timeIntervalSince(quitDate)

        for i in 0..<badges.count {
            if elapsed >= badges[i].duration {
                badges[i].isUnlocked = true
            } else {
                badges[i].isUnlocked = false
            }
        }
    }
}
