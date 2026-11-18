import Foundation
import SwiftUI
import Combine

class HealthViewModel: ObservableObject {
    @Published var milestones: [HealthMilestone] = []

    init() {
        setupMilestones()
        updateProgress()
    }

    func setupMilestones() {
        self.milestones = HealthMilestone.all
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
