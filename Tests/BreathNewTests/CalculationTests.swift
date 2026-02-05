import XCTest
@testable import BreathNew

final class CalculationTests: XCTestCase {

    override func setUp() {
        super.setUp()
        DataManager.shared.resetAllData()
    }

    func testMoneySavedCalculation() {
        // Given
        let quitDate = Date().addingTimeInterval(-86400) // 24 hours ago
        let userData = UserData(
            quitDate: quitDate,
            cigarettesPerDay: 20,
            packSize: 20,
            packPrice: 10.0,
            timePerCigarette: 11
        )
        DataManager.shared.saveUserData(userData)

        // When
        let viewModel = DashboardViewModel()
        viewModel.updateCalculations()

        // Then
        // 24 hours = 1 day = 20 cigs
        // Cost = (10/20) * 20 = 10.0

        XCTAssertEqual(viewModel.cigarettesNotSmoked, 20.0, accuracy: 0.1)
        XCTAssertEqual(viewModel.moneySaved, 10.0, accuracy: 0.01)
    }

    func testLifeRegainedCalculation() {
        // Given
        let quitDate = Date().addingTimeInterval(-86400) // 24 hours ago
        let userData = UserData(
            quitDate: quitDate,
            cigarettesPerDay: 20,
            packSize: 20,
            packPrice: 10.0,
            timePerCigarette: 11
        )
        DataManager.shared.saveUserData(userData)

        // When
        let viewModel = DashboardViewModel()
        viewModel.updateCalculations()

        // Then
        // 20 cigs * 11 mins = 220 mins
        // 220 * 60 = 13200 seconds

        XCTAssertEqual(viewModel.lifeRegained, 13200, accuracy: 1.0)
    }

    func testLungHealthProgress() {
        // Given
        // 6 months = 0.5 years (approx)
        let sixMonths: TimeInterval = 31_536_000 / 2
        let quitDate = Date().addingTimeInterval(-sixMonths)
        let userData = UserData(quitDate: quitDate)
        DataManager.shared.saveUserData(userData)

        // When
        let viewModel = DashboardViewModel()
        viewModel.updateCalculations()

        // Then
        XCTAssertEqual(viewModel.lungHealthProgress, 0.5, accuracy: 0.01)
    }
}
