import Foundation
import SwiftUI
import Combine

struct PriceHistoryRow: Identifiable {
    let entry: PriceEntry
    let isBase: Bool
    let isCurrent: Bool
    let isUpcoming: Bool
    let change: Double?

    var id: UUID { entry.id }
}

struct PriceEditorState: Identifiable {
    let id = UUID()
    let entry: PriceEntry?
    let isBase: Bool
    let previousPrice: Double?
    let earliestDate: Date
    let canDelete: Bool
}

class SettingsViewModel: ObservableObject {
    @Published var userData: UserData
    @Published var currencyCode: String

    @Published var priceEditor: PriceEditorState? = nil

    private var cancellables = Set<AnyCancellable>()
    private var isInitialLoad = true

    init() {
        self.userData = DataManager.shared.userData
        self.currencyCode = DataManager.shared.currencyCode

        DataManager.shared.$userData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newData in
                guard let self = self else { return }
                if self.isInitialLoad {
                    self.userData = newData
                    self.isInitialLoad = false
                }
            }
            .store(in: &cancellables)

        $userData
            .dropFirst()
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { updatedData in
                guard updatedData != DataManager.shared.userData else { return }
                DataManager.shared.saveUserData(updatedData)
            }
            .store(in: &cancellables)

        $currencyCode
            .dropFirst()
            .sink { newCode in
                DataManager.shared.currencyCode = newCode
            }
            .store(in: &cancellables)
    }

    var currentPrice: Double {
        userData.currentPrice
    }

    var priceRows: [PriceHistoryRow] {
        let sorted = userData.sortedPriceHistory
        let now = Date()
        let currentID = sorted.last(where: { $0.date <= now })?.id ?? sorted.first?.id

        return sorted.enumerated().map { index, entry in
            let previous = index > 0 ? sorted[index - 1].price : nil
            return PriceHistoryRow(
                entry: entry,
                isBase: index == 0,
                isCurrent: entry.id == currentID,
                isUpcoming: index > 0 && entry.date > now,
                change: previous.flatMap { $0 > 0 ? (entry.price - $0) / $0 : nil }
            )
        }
        .reversed()
    }

    var canDeletePriceEntries: Bool {
        userData.priceHistory.count > 1
    }

    func startAddingPrice() {
        let sorted = userData.sortedPriceHistory
        priceEditor = PriceEditorState(
            entry: nil,
            isBase: false,
            previousPrice: sorted.isEmpty ? nil : currentPrice,
            earliestDate: sorted.first?.date ?? userData.quitDate,
            canDelete: false
        )
    }

    func startEditing(_ entry: PriceEntry) {
        let sorted = userData.sortedPriceHistory
        guard let index = sorted.firstIndex(where: { $0.id == entry.id }) else { return }
        priceEditor = PriceEditorState(
            entry: entry,
            isBase: index == 0,
            previousPrice: index > 0 ? sorted[index - 1].price : nil,
            earliestDate: sorted.first?.date ?? userData.quitDate,
            canDelete: canDeletePriceEntries
        )
    }

    func savePrice(_ price: Double, date: Date) {
        guard price > 0, let editor = priceEditor else { return }
        commitPendingEdits()
        if let entry = editor.entry {
            DataManager.shared.updatePriceEntry(id: entry.id, newPrice: price, newDate: date)
        } else {
            DataManager.shared.addPriceEntry(price: price, date: date)
        }
        userData = DataManager.shared.userData
        priceEditor = nil
    }

    func deleteEntry(_ entry: PriceEntry) {
        commitPendingEdits()
        DataManager.shared.removePriceEntry(id: entry.id)
        userData = DataManager.shared.userData
        priceEditor = nil
    }

    func removePriceEntry(at offsets: IndexSet) {
        let rows = priceRows
        for entry in offsets.map({ rows[$0].entry }) {
            deleteEntry(entry)
        }
    }

    func resetProgress() {
        commitPendingEdits()
        DataManager.shared.resetProgress()
        userData = DataManager.shared.userData
    }

    private func commitPendingEdits() {
        if userData != DataManager.shared.userData {
            DataManager.shared.saveUserData(userData)
        }
    }
}
