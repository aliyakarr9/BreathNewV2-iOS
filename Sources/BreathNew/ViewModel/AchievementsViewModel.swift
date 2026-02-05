import Foundation

class AchievementsViewModel: ObservableObject {
    @Published var badges: [Badge] = []

    init() {
        setupBadges()
        updateBadges()
    }

    func setupBadges() {
        self.badges = [
            Badge(title: "1 Hour", duration: 3600, iconName: "hourglass.bottomhalf.fill"),
            Badge(title: "6 Hours", duration: 6 * 3600, iconName: "sun.max.fill"),
            Badge(title: "12 Hours", duration: 12 * 3600, iconName: "moon.stars.fill"),
            Badge(title: "1 Day", duration: 24 * 3600, iconName: "star.fill"),
            Badge(title: "3 Days", duration: 3 * 24 * 3600, iconName: "star.circle.fill"),
            Badge(title: "1 Week", duration: 7 * 24 * 3600, iconName: "crown.fill"),
            Badge(title: "1 Month", duration: 30 * 24 * 3600, iconName: "rosette"),
            Badge(title: "3 Months", duration: 90 * 24 * 3600, iconName: "shield.fill"),
            Badge(title: "6 Months", duration: 180 * 24 * 3600, iconName: "flame.fill"),
            Badge(title: "1 Year", duration: 365 * 24 * 3600, iconName: "trophy.fill")
        ]
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
