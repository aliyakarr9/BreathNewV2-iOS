import Foundation

struct Badge: Identifiable, Equatable {
    let id: UUID = UUID()
    let title: String
    let duration: TimeInterval
    let iconName: String
    var isUnlocked: Bool = false
}
