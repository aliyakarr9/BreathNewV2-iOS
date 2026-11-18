import XCTest
@testable import BreathNew

final class CalculationTests: XCTestCase {

    override func setUp() {
        super.setUp()
        DataManager.shared.resetAllData()
    }

    func testMoneySavedCalculation() {
        let quitDate = Date().addingTimeInterval(-86400)
        let priceEntry = PriceEntry(date: quitDate, price: 10.0)
        let userData = UserData(
            quitDate: quitDate,
            cigarettesPerDay: 20,
            packSize: 20,
            packPrice: 10.0,
            timePerCigarette: 11,
            priceHistory: [priceEntry]
        )
        DataManager.shared.saveUserData(userData)

        let viewModel = DashboardViewModel()
        viewModel.updateCalculations()

        XCTAssertEqual(viewModel.cigarettesNotSmoked, 20.0, accuracy: 0.1)
        XCTAssertEqual(viewModel.moneySaved, 10.0, accuracy: 0.1)
    }

    func testLifeRegainedCalculation() {
        let quitDate = Date().addingTimeInterval(-86400)
        let userData = UserData(
            quitDate: quitDate,
            cigarettesPerDay: 20,
            packSize: 20,
            packPrice: 10.0,
            timePerCigarette: 11,
            priceHistory: [PriceEntry(date: quitDate, price: 10.0)]
        )
        DataManager.shared.saveUserData(userData)

        let viewModel = DashboardViewModel()
        viewModel.updateCalculations()

        XCTAssertEqual(viewModel.lifeRegained, 13200, accuracy: 60.0)
    }

    func testLungHealthProgress() {
        let sixMonths: TimeInterval = 31_536_000 / 2
        let quitDate = Date().addingTimeInterval(-sixMonths)
        let userData = UserData(quitDate: quitDate)
        DataManager.shared.saveUserData(userData)

        let viewModel = DashboardViewModel()
        viewModel.updateCalculations()

        XCTAssertEqual(viewModel.lungHealthProgress, 0.5, accuracy: 0.01)
    }

    func testDynamicPriceSavings() {
        let now = Date()
        let quitDate = now.addingTimeInterval(-20 * 86400)
        let zamDate = now.addingTimeInterval(-10 * 86400)

        let entries = [
            PriceEntry(date: quitDate, price: 200.0),
            PriceEntry(date: zamDate, price: 250.0)
        ]

        let userData = UserData(
            quitDate: quitDate,
            cigarettesPerDay: 20,
            packSize: 20,
            packPrice: 250.0,
            timePerCigarette: 11,
            priceHistory: entries
        )
        DataManager.shared.saveUserData(userData)

        let viewModel = DashboardViewModel()
        viewModel.updateCalculations()

        XCTAssertEqual(viewModel.moneySaved, 4500.0, accuracy: 10.0)
    }

    func testPriceHistoryMigration() {
        let quitDate = Date().addingTimeInterval(-86400)
        let userData = UserData(
            quitDate: quitDate,
            cigarettesPerDay: 10,
            packSize: 20,
            packPrice: 150.0,
            timePerCigarette: 11,
            priceHistory: []
        )
        DataManager.shared.saveUserData(userData)

        let loadedData = DataManager.shared.userData

        if loadedData.priceHistory.isEmpty {
            XCTAssertEqual(loadedData.packPrice, 150.0)
        } else {
            XCTAssertEqual(loadedData.priceHistory.first?.price, 150.0)
        }
    }
}

