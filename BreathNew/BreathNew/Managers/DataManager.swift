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
        guard price > 0 else { return }

        guard let base = userData.basePriceEntry else {
            userData.priceHistory = [PriceEntry(date: userData.quitDate, price: price)]
            syncAndPersist()
            return
        }

        let effectiveDate = changeDate(for: date, after: base)
        if let index = userData.priceHistory.firstIndex(where: {
            $0.id != base.id && Calendar.current.isDate($0.date, inSameDayAs: effectiveDate)
        }) {
            userData.priceHistory[index].price = price
            userData.priceHistory[index].date = effectiveDate
        } else {
            userData.priceHistory.append(PriceEntry(date: effectiveDate, price: price))
        }
        syncAndPersist()
    }

    func removePriceEntry(id: UUID) {
        guard userData.priceHistory.count > 1 else { return }
        userData.priceHistory.removeAll { $0.id == id }
        syncAndPersist()
    }

    func updatePriceEntry(id: UUID, newPrice: Double, newDate: Date) {
        guard newPrice > 0,
              let base = userData.basePriceEntry,
              let index = userData.priceHistory.firstIndex(where: { $0.id == id }) else { return }

        userData.priceHistory[index].price = newPrice

        if id != base.id {
            let effectiveDate = changeDate(for: newDate, after: base)
            userData.priceHistory[index].date = effectiveDate
            userData.priceHistory.removeAll {
                $0.id != id && $0.id != base.id && Calendar.current.isDate($0.date, inSameDayAs: effectiveDate)
            }
        }
        syncAndPersist()
    }

    private func changeDate(for date: Date, after base: PriceEntry) -> Date {
        let dayStart = Calendar.current.startOfDay(for: date)
        return dayStart > base.date ? dayStart : base.date.addingTimeInterval(1)
    }

    private func syncAndPersist() {
        userData.packPrice = userData.currentPrice
        persistUserData()
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

