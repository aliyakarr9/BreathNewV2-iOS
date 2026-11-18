import Foundation

struct PriceEntry: Codable, Equatable, Identifiable {
    let id: UUID
    var date: Date
    var price: Double

    init(id: UUID = UUID(), date: Date, price: Double) {
        self.id = id
        self.date = date
        self.price = price
    }
}

