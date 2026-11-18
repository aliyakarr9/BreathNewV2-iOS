import Foundation
import SwiftUI
import Combine

class DashboardViewModel: ObservableObject {
    @Published var timeElapsed: DateComponents = DateComponents()
    @Published var moneySaved: Double = 0.0
    @Published var cigarettesNotSmoked: Double = 0.0
    @Published var lifeRegained: TimeInterval = 0.0
    @Published var lungHealthProgress: Double = 0.0
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

        self.moneySaved = calculateDynamicSavings(data: data, now: now)

        let lifeRegainedPerCigarette: TimeInterval = Double(data.timePerCigarette) * 60
        self.lifeRegained = totalCigarettesNotSmoked * lifeRegainedPerCigarette

        let oneYearSeconds: Double = 31_536_000
        self.lungHealthProgress = min(elapsed / oneYearSeconds, 1.0)

        self.formattedMoney = formatMoney(moneySaved)
        self.formattedLifeRegained = formatLifeRegained(lifeRegained)
    }

    private func calculateDynamicSavings(data: UserData, now: Date) -> Double {
        guard data.packSize > 0, !data.priceHistory.isEmpty else {
            if data.packSize > 0 {
                let daysElapsed = now.timeIntervalSince(data.quitDate) / 86400.0
                let costPerCig = data.packPrice / Double(data.packSize)
                return daysElapsed * Double(data.cigarettesPerDay) * costPerCig
            }
            return 0.0
        }

        let sortedEntries = data.priceHistory.sorted(by: { $0.date < $1.date })
        let cigarettesPerDay = Double(data.cigarettesPerDay)
        let packSize = Double(data.packSize)
        var totalSavings: Double = 0.0

        for i in 0..<sortedEntries.count {
            let entryDate = sortedEntries[i].date
            let entryPrice = sortedEntries[i].price

            let periodStart = max(entryDate, data.quitDate)

            let periodEnd: Date
            if i + 1 < sortedEntries.count {
                periodEnd = sortedEntries[i + 1].date
            } else {
                periodEnd = now
            }

            guard periodEnd > periodStart else { continue }

            let periodDays = periodEnd.timeIntervalSince(periodStart) / 86400.0
            let costPerCig = entryPrice / packSize
            totalSavings += periodDays * cigarettesPerDay * costPerCig
        }

        return totalSavings
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
            return "\(days)\(d) \(hours)\(h)"
        } else if hours > 0 {
            return "\(hours)\(h) \(minutes)\(m)"
        } else {
            return "\(minutes)\(m)"
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

