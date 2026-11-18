import Foundation

struct HealthMilestone: Identifiable, Equatable {
    let id: UUID = UUID()
    let title: String
    let description: String
    let duration: TimeInterval

    var isCompleted: Bool = false
    var progress: Double = 0.0
}
