import Foundation

struct UserData: Codable, Equatable {
    var quitDate: Date
    var cigarettesPerDay: Int
    var packSize: Int
    var packPrice: Double
    var timePerCigarette: Int // in minutes

    init(quitDate: Date = Date(), cigarettesPerDay: Int = 0, packSize: Int = 20, packPrice: Double = 0.0, timePerCigarette: Int = 11) {
        self.quitDate = quitDate
        self.cigarettesPerDay = cigarettesPerDay
        self.packSize = packSize
        self.packPrice = packPrice
        self.timePerCigarette = timePerCigarette
    }
}
