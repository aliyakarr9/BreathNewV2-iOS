import Foundation

class HealthViewModel: ObservableObject {
    @Published var milestones: [HealthMilestone] = []

    init() {
        setupMilestones()
        updateProgress()
    }

    func setupMilestones() {
        self.milestones = [
            HealthMilestone(title: "20 Minutes", description: "Blood pressure and pulse return to normal.", duration: 20 * 60),
            HealthMilestone(title: "8 Hours", description: "Nicotine and carbon monoxide levels halve. Oxygen levels return to normal.", duration: 8 * 3600),
            HealthMilestone(title: "24 Hours", description: "Carbon monoxide eliminated. Lungs start clearing mucus.", duration: 24 * 3600),
            HealthMilestone(title: "48 Hours", description: "Nicotine eliminated. Taste and smell improve.", duration: 48 * 3600),
            HealthMilestone(title: "72 Hours", description: "Breathing becomes easier. Energy levels increase.", duration: 72 * 3600),
            HealthMilestone(title: "2 Weeks", description: "Circulation improves. Walking and running become easier.", duration: 14 * 24 * 3600),
            HealthMilestone(title: "1 Year", description: "Coronary heart disease risk drops to half of a smoker's.", duration: 365 * 24 * 3600)
        ]
    }

    func updateProgress() {
        let quitDate = DataManager.shared.userData.quitDate
        let elapsed = Date().timeIntervalSince(quitDate)

        for i in 0..<milestones.count {
            let duration = milestones[i].duration
            if elapsed >= duration {
                milestones[i].isCompleted = true
                milestones[i].progress = 1.0
            } else {
                milestones[i].isCompleted = false
                milestones[i].progress = max(0.0, elapsed / duration)
            }
        }
    }
}
