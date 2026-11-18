import Foundation

struct UserData: Codable, Equatable {
    var quitDate: Date
    var cigarettesPerDay: Int
    var packSize: Int
    var packPrice: Double
    var timePerCigarette: Int
    var priceHistory: [PriceEntry]

    var currentPrice: Double {
        priceHistory.sorted(by: { $0.date < $1.date }).last?.price ?? packPrice
    }

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
