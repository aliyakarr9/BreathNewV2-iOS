import Foundation

class DataManager: ObservableObject {
    static let shared = DataManager()

    private let userDataKey = "breathnew_user_data"
    private let onboardingKey = "breathnew_onboarding_completed"

    @Published var userData: UserData = UserData()
    @Published var isOnboardingCompleted: Bool = false

    private init() {
        loadData()
    }

    private func loadData() {
        // Load UserData
        if let data = UserDefaults.standard.data(forKey: userDataKey),
           let decoded = try? JSONDecoder().decode(UserData.self, from: data) {
            self.userData = decoded
        }

        // Load Onboarding Status
        self.isOnboardingCompleted = UserDefaults.standard.bool(forKey: onboardingKey)
    }

    func saveUserData(_ data: UserData) {
        self.userData = data
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: userDataKey)
        }
    }

    func completeOnboarding() {
        self.isOnboardingCompleted = true
        UserDefaults.standard.set(true, forKey: onboardingKey)
    }

    func resetProgress() {
        var newData = self.userData
        newData.quitDate = Date()
        saveUserData(newData)
    }

    func resetAllData() {
        UserDefaults.standard.removeObject(forKey: userDataKey)
        UserDefaults.standard.removeObject(forKey: onboardingKey)
        self.userData = UserData()
        self.isOnboardingCompleted = false
    }
}
