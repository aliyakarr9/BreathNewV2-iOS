import Foundation
import Combine

class DashboardViewModel: ObservableObject {
    @Published var timeElapsed: DateComponents = DateComponents()
    @Published var moneySaved: Double = 0.0
    @Published var cigarettesNotSmoked: Double = 0.0
    @Published var lifeRegained: TimeInterval = 0.0 // in seconds
    @Published var lungHealthProgress: Double = 0.0 // 0.0 to 1.0

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
        // Update calculations whenever UserData changes
        DataManager.shared.$userData
            .sink { [weak self] _ in
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

        // Ensure we don't calculate future dates if quitDate is somehow in future (unlikely but safe)
        let elapsed = now.timeIntervalSince(quitDate)
        guard elapsed > 0 else {
            resetValues()
            return
        }

        // Time Elapsed Components
        let calendar = Calendar.current
        timeElapsed = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: quitDate, to: now)

        // Basic Stats
        let daysElapsed = elapsed / 86400.0
        let cigarettesPerDay = Double(data.cigarettesPerDay)
        let totalCigarettesNotSmoked = daysElapsed * cigarettesPerDay
        self.cigarettesNotSmoked = totalCigarettesNotSmoked

        // Money Saved
        // (Pack Price / Pack Size) * Cigarettes Not Smoked
        if data.packSize > 0 {
            let costPerCigarette = data.packPrice / Double(data.packSize)
            self.moneySaved = costPerCigarette * totalCigarettesNotSmoked
        }

        // Life Regained
        // 1 cigarette = 11 minutes (660 seconds)
        // result in seconds
        let lifeRegainedPerCigarette: TimeInterval = 11 * 60
        self.lifeRegained = totalCigarettesNotSmoked * lifeRegainedPerCigarette

        // Lung Health (1 Year = 100%)
        // 1 year in seconds = 365 * 86400 = 31,536,000
        let oneYearSeconds: Double = 31_536_000
        self.lungHealthProgress = min(elapsed / oneYearSeconds, 1.0)
    }

    private func resetValues() {
        timeElapsed = DateComponents()
        moneySaved = 0.0
        cigarettesNotSmoked = 0.0
        lifeRegained = 0.0
        lungHealthProgress = 0.0
    }
}
