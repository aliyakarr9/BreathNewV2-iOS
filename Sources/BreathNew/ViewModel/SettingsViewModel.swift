import Foundation
import SwiftUI
import Combine

class SettingsViewModel: ObservableObject {
    @Published var userData: UserData
    @Published var notificationsEnabled: Bool = false
    @Published var currencyCode: String
    @Published var newPrice: Double = 0.0
    @Published var newPriceDate: Date = Date()

    @Published var editingEntry: PriceEntry? = nil
    @Published var editPrice: Double = 0.0
    @Published var editDate: Date = Date()
    @Published var isEditingPrice: Bool = false

    var sortedPriceHistory: [PriceEntry] {
        userData.priceHistory.sorted(by: { $0.date > $1.date })
    }

    private var cancellables = Set<AnyCancellable>()

    init() {
        self.userData = DataManager.shared.userData
        self.currencyCode = DataManager.shared.currencyCode

        DataManager.shared.$userData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newData in
                self?.userData = newData
            }
            .store(in: &cancellables)
    }

    func saveChanges() {
        DataManager.shared.saveUserData(userData)
        DataManager.shared.currencyCode = currencyCode
    }

    func addPriceUpdate() {
        guard newPrice > 0 else { return }
        DataManager.shared.addPriceEntry(price: newPrice, date: newPriceDate)
        newPrice = 0.0
        newPriceDate = Date()
    }

    func removePriceEntry(at offsets: IndexSet) {
        let entriesToDelete = offsets.map { sortedPriceHistory[$0] }
        for entry in entriesToDelete {
            DataManager.shared.removePriceEntry(id: entry.id)
        }
    }

    func startEditing(_ entry: PriceEntry) {
        editingEntry = entry
        editPrice = entry.price
        editDate = entry.date
        isEditingPrice = true
    }

    func saveEdit() {
        guard let entry = editingEntry, editPrice > 0 else { return }
        DataManager.shared.updatePriceEntry(id: entry.id, newPrice: editPrice, newDate: editDate)
        isEditingPrice = false
        editingEntry = nil
    }

    func cancelEdit() {
        isEditingPrice = false
        editingEntry = nil
    }

    func deleteEditingEntry() {
        guard let entry = editingEntry else { return }
        DataManager.shared.removePriceEntry(id: entry.id)
        isEditingPrice = false
        editingEntry = nil
    }

    func deleteEntry(_ entry: PriceEntry) {
        DataManager.shared.removePriceEntry(id: entry.id)
    }

    func resetProgress() {
        DataManager.shared.resetProgress()
    }
}
