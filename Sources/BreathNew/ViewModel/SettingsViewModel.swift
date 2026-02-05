import Foundation

class SettingsViewModel: ObservableObject {
    @Published var userData: UserData
    @Published var notificationsEnabled: Bool = false // Placeholder for actual logic

    init() {
        self.userData = DataManager.shared.userData
    }

    func saveChanges() {
        DataManager.shared.saveUserData(userData)
    }

    func resetProgress() {
        DataManager.shared.resetProgress()
        self.userData = DataManager.shared.userData
    }
}
