import Foundation
import SwiftUI
import Combine

class DashboardViewModel: ObservableObject {
    @Published var timeElapsed: DateComponents = DateComponents()
    @Published var moneySaved: Double = 0.0
    @Published var cigarettesNotSmoked: Double = 0.0
    @Published var lifeRegained: TimeInterval = 0.0
    @Published var lungHealthProgress: Double = 0.0
    @Published var daysElapsed: Double = 0.0
    @Published var formattedMoney: String = ""
    @Published var formattedLifeRegained: String = ""

    private var cancellables = Set<AnyCancellable>()
    private var timer: AnyCancellable?

    init() {
        setupSubscriptions()
        startTimer()
    }

    deinit {
        timer?.cancel()
    }

    private func setupSubscriptions() {
        DataManager.shared.$userData
            .combineLatest(DataManager.shared.$currencyCode)
            .sink { [weak self] _, _ in
                self?.updateCalculations()
            }
            .store(in: &cancellables)
    }

    private func startTimer() {
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateCalculations()
            }
    }

    func updateCalculations() {
        let data = DataManager.shared.userData
        let now = Date()
        let quitDate = data.quitDate

        let elapsed = now.timeIntervalSince(quitDate)
        guard elapsed > 0 else {
            resetValues()
            return
        }

        let calendar = Calendar.current
        timeElapsed = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: quitDate, to: now)

        let daysElapsed = elapsed / 86400.0
        let cigarettesPerDay = Double(data.cigarettesPerDay)
        let totalCigarettesNotSmoked = daysElapsed * cigarettesPerDay
        self.cigarettesNotSmoked = totalCigarettesNotSmoked

        self.moneySaved = data.moneySaved(until: now)

        let lifeRegainedPerCigarette: TimeInterval = Double(data.timePerCigarette) * 60
        self.lifeRegained = totalCigarettesNotSmoked * lifeRegainedPerCigarette

        let daysForLung = elapsed / 86400.0
        self.daysElapsed = daysForLung
        self.lungHealthProgress = min(pow(min(daysForLung / 365.0, 1.0), 0.35), 1.0)

        self.formattedMoney = formatMoney(moneySaved)
        self.formattedLifeRegained = formatLifeRegained(lifeRegained)
    }

    func formatMoney(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = DataManager.shared.currencyCode
        return formatter.string(from: NSNumber(value: amount)) ?? "\(DataManager.shared.currencyCode) 0.00"
    }

    func formatLifeRegained(_ seconds: TimeInterval) -> String {
        let days = Int(seconds) / 86400
        let hours = (Int(seconds) % 86400) / 3600
        let minutes = (Int(seconds) % 3600) / 60

        let isTurkish = UserDefaults.standard.string(forKey: "language") == "tr"

        let d = isTurkish ? "g" : "d"
        let h = isTurkish ? "sa" : "h"
        let m = isTurkish ? "dk" : "m"

        if days > 0 {
            return "\(days) \(d) \(hours) \(h)"
        } else if hours > 0 {
            return "\(hours) \(h) \(minutes) \(m)"
        } else {
            return "\(minutes) \(m)"
        }
    }

    private func resetValues() {
        timeElapsed = DateComponents()
        moneySaved = 0.0
        cigarettesNotSmoked = 0.0
        lifeRegained = 0.0
        lungHealthProgress = 0.0
        formattedMoney = ""
        formattedLifeRegained = ""
    }
}

