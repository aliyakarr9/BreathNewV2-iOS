import Foundation
import SwiftUI
import Combine

class OnboardingViewModel: ObservableObject {
    @Published var quitDate: Date = Date()
    @Published var cigarettesPerDay: Int = 10
    @Published var packSize: Int = 20
    @Published var packPrice: Double = 5.0
    @Published var timePerCigarette: Int = 11

    func save() {
        let userData = UserData(
            quitDate: quitDate,
            cigarettesPerDay: cigarettesPerDay,
            packSize: packSize,
            packPrice: packPrice,
            timePerCigarette: timePerCigarette
        )
        DataManager.shared.saveUserData(userData)
        DataManager.shared.completeOnboarding()
    }
}
