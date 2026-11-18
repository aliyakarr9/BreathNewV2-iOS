import Foundation

struct UserData: Codable, Equatable {
    var quitDate: Date
    var cigarettesPerDay: Int
    var packSize: Int
    var packPrice: Double
    var timePerCigarette: Int
    var priceHistory: [PriceEntry]

    init(
        quitDate: Date = Date(),
        cigarettesPerDay: Int = 0,
        packSize: Int = 20,
        packPrice: Double = 0.0,
        timePerCigarette: Int = 11,
        priceHistory: [PriceEntry] = []
    ) {
        self.quitDate = quitDate
        self.cigarettesPerDay = cigarettesPerDay
        self.packSize = packSize
        self.packPrice = packPrice
        self.timePerCigarette = timePerCigarette
        self.priceHistory = priceHistory
    }
}

extension UserData {
    var sortedPriceHistory: [PriceEntry] {
        priceHistory.sorted(by: { $0.date < $1.date })
    }

    var basePriceEntry: PriceEntry? {
        sortedPriceHistory.first
    }

    func price(at date: Date) -> Double {
        let sorted = sortedPriceHistory
        guard let first = sorted.first else { return packPrice }
        return sorted.last(where: { $0.date <= date })?.price ?? first.price
    }

    var currentPrice: Double {
        price(at: Date())
    }

    func moneySaved(until now: Date = Date()) -> Double {
        guard packSize > 0, now > quitDate else { return 0 }

        let packsPerDay = Double(cigarettesPerDay) / Double(packSize)
        var total = 0.0
        var periodStart = quitDate
        var periodPrice = price(at: quitDate)

        for entry in sortedPriceHistory where entry.date > quitDate && entry.date < now {
            total += entry.date.timeIntervalSince(periodStart) / 86400.0 * packsPerDay * periodPrice
            periodStart = entry.date
            periodPrice = entry.price
        }

        total += now.timeIntervalSince(periodStart) / 86400.0 * packsPerDay * periodPrice
        return total
    }
}
