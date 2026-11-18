import Foundation
import SwiftUI
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()

    private let userDataKey = "breathnew_user_data"
    private let onboardingKey = "breathnew_onboarding_completed"
    private let currencyKey = "currencyCode"

    @Published var userData: UserData = UserData()
    @Published var isOnboardingCompleted: Bool = false
    @Published var currencyCode: String {
        didSet {
            UserDefaults.standard.set(currencyCode, forKey: currencyKey)
        }
    }

    private init() {
        self.currencyCode = UserDefaults.standard.string(forKey: currencyKey) ?? "TRY"
        loadData()
    }

    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: userDataKey),
           let decoded = try? JSONDecoder().decode(UserData.self, from: data) {
            self.userData = decoded
            migrateIfNeeded()
        }

        self.isOnboardingCompleted = UserDefaults.standard.bool(forKey: onboardingKey)
    }

    private func migrateIfNeeded() {
        if userData.priceHistory.isEmpty && userData.packPrice > 0 {
            let initialEntry = PriceEntry(date: userData.quitDate, price: userData.packPrice)
            userData.priceHistory = [initialEntry]
            persistUserData()
        }
    }

    func saveUserData(_ data: UserData) {
        self.userData = data
        persistUserData()
    }

    func addPriceEntry(price: Double, date: Date = Date()) {
        let entry = PriceEntry(date: date, price: price)
        userData.priceHistory.append(entry)
        userData.packPrice = price
        persistUserData()
    }

    func removePriceEntry(id: UUID) {
        userData.priceHistory.removeAll { $0.id == id }
        userData.packPrice = userData.currentPrice
        persistUserData()
    }

    func updatePriceEntry(id: UUID, newPrice: Double, newDate: Date) {
        if let index = userData.priceHistory.firstIndex(where: { $0.id == id }) {
            userData.priceHistory[index].price = newPrice
            userData.priceHistory[index].date = newDate
            userData.packPrice = userData.currentPrice
            persistUserData()
        }
    }

    func completeOnboarding() {
        self.isOnboardingCompleted = true
        UserDefaults.standard.set(true, forKey: onboardingKey)
    }

    func resetProgress() {
        userData.quitDate = Date()
        let currentPrice = userData.currentPrice
        userData.priceHistory = [PriceEntry(date: Date(), price: currentPrice)]
        persistUserData()
    }

    func resetAllData() {
        UserDefaults.standard.removeObject(forKey: userDataKey)
        UserDefaults.standard.removeObject(forKey: onboardingKey)
        self.userData = UserData()
        self.isOnboardingCompleted = false
    }

    private func persistUserData() {
        if let encoded = try? JSONEncoder().encode(userData) {
            UserDefaults.standard.set(encoded, forKey: userDataKey)
        }
    }
}

