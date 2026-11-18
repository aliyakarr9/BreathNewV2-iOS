import SwiftUI
import UIKit

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @ObservedObject private var notifications = NotificationManager.shared
    @EnvironmentObject var languageManager: LanguageManager
    @State private var showingResetAlert = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Language")) {
                    Picker("Language", selection: $languageManager.selectedLanguage) {
                        Text("English 🇬🇧").tag(LanguageManager.english)
                        Text("Türkçe 🇹🇷").tag(LanguageManager.turkish)
                    }
                }

                Section(header: Text("Currency")) {
                    Picker("Select Currency", selection: $viewModel.currencyCode) {
                        Text("Türk Lirası (₺)").tag("TRY")
                        Text("US Dollar ($)").tag("USD")
                        Text("Euro (€)").tag("EUR")
                        Text("British Pound (£)").tag("GBP")
                    }
                }

                Section {
                    DatePicker("Quit Date", selection: $viewModel.userData.quitDate, displayedComponents: [.date, .hourAndMinute])

                    Stepper("Cigarettes/Day: \(viewModel.userData.cigarettesPerDay)", value: $viewModel.userData.cigarettesPerDay, in: 0...100)

                    Stepper("Pack Size: \(viewModel.userData.packSize)", value: $viewModel.userData.packSize, in: 1...50)

                    Stepper("Time/Cigarette: \(viewModel.userData.timePerCigarette) min", value: $viewModel.userData.timePerCigarette, in: 1...60)
                } header: {
                    Text("My Info")
                } footer: {
                    Text("Your info is saved automatically.")
                }

                Section {
                    LabeledContent("Current Price") {
                        Text(formatPrice(viewModel.currentPrice))
                            .font(.headline)
                            .foregroundStyle(.primary)
                    }

                    Button {
                        viewModel.startAddingPrice()
                    } label: {
                        Label("Add Price Change", systemImage: "plus.circle.fill")
                    }
                } header: {
                    Text("Pack Price")
                } footer: {
                    Text("When cigarette prices increase, add the new price here with its effective date. Your savings will be calculated accurately based on price history.")
                }

                Section(header: Text("Price History")) {
                    ForEach(viewModel.priceRows) { row in
                        Button {
                            viewModel.startEditing(row.entry)
                        } label: {
                            PriceHistoryRowView(row: row, price: formatPrice(row.entry.price))
                        }
                        .buttonStyle(.plain)
                    }
                    .onDelete(perform: viewModel.removePriceEntry)
                    .deleteDisabled(!viewModel.canDeletePriceEntries)
                }

                Section {
                    Toggle("Notifications", isOn: Binding(
                        get: { notifications.isEnabled },
                        set: { enabled in
                            Task { await notifications.setEnabled(enabled) }
                        }
                    ))
                    .alert("Notifications Are Off", isPresented: $notifications.permissionDenied) {
                        Button("Open Settings") {
                            if let url = URL(string: UIApplication.openNotificationSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        }
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("Allow notifications for BreathNew in Settings to turn this on.")
                    }
                } header: {
                    Text("Preferences")
                } footer: {
                    Text("Get notified when you reach a health milestone or earn a badge.")
                }

                Section {
                    Button(action: {
                        showingResetAlert = true
                    }) {
                        Text("I Smoked (Reset Progress)")
                            .foregroundColor(.red)
                    }
                    .alert("Are you sure?", isPresented: $showingResetAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("Yes, Reset", role: .destructive) {
                            viewModel.resetProgress()
                        }
                    } message: {
                        Text("This will reset your quit date to now. Don't give up!")
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(item: $viewModel.priceEditor) { editor in
                PriceEditorSheet(
                    editor: editor,
                    currencyCode: viewModel.currencyCode,
                    onSave: { price, date in viewModel.savePrice(price, date: date) },
                    onDelete: { if let entry = editor.entry { viewModel.deleteEntry(entry) } },
                    onCancel: { viewModel.priceEditor = nil }
                )
            }
        }
    }

    private func formatPrice(_ price: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = viewModel.currencyCode
        return formatter.string(from: NSNumber(value: price)) ?? "\(price)"
    }
}

struct PriceHistoryRowView: View {
    let row: PriceHistoryRow
    let price: String

    private var caption: LocalizedStringKey {
        if row.isBase { return "Starting price" }
        if row.isUpcoming { return "Not in effect yet" }
        return "Price change"
    }

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(row.entry.date, format: .dateTime.day().month(.wide).year())
                    .font(.body)
                Text(caption)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(price)
                    .font(.headline)
                    .monospacedDigit()
                    .foregroundStyle(row.isCurrent ? Color.primaryGreen : Color.primary)

                if let change = row.change {
                    Text(change, format: .percent.precision(.fractionLength(0...1)).sign(strategy: .always()))
                        .font(.caption)
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                } else if row.isCurrent {
                    Text("In effect now")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tertiary)
                .accessibilityHidden(true)
        }
        .contentShape(Rectangle())
        .opacity(row.isUpcoming ? 0.6 : 1)
        .accessibilityElement(children: .combine)
    }
}

struct PriceEditorSheet: View {
    let editor: PriceEditorState
    let currencyCode: String
    let onSave: (Double, Date) -> Void
    let onDelete: () -> Void
    let onCancel: () -> Void

    @State private var price: Double
    @State private var date: Date

    init(
        editor: PriceEditorState,
        currencyCode: String,
        onSave: @escaping (Double, Date) -> Void,
        onDelete: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.editor = editor
        self.currencyCode = currencyCode
        self.onSave = onSave
        self.onDelete = onDelete
        self.onCancel = onCancel
        self._price = State(initialValue: editor.entry?.price ?? 0)
        self._date = State(initialValue: max(editor.entry?.date ?? Date(), editor.earliestDate))
    }

    private var title: LocalizedStringKey {
        if editor.isBase { return "Starting Price" }
        return editor.entry == nil ? "Add Price Change" : "Edit Price Entry"
    }

    private var change: Double? {
        guard let previous = editor.previousPrice, previous > 0, price > 0 else { return nil }
        return (price - previous) / previous
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text(editor.isBase ? LocalizedStringKey("Pack Price") : LocalizedStringKey("New Pack Price"))
                        PriceField(value: $price, currencyCode: currencyCode, focusOnAppear: editor.entry == nil)
                    }

                    if !editor.isBase {
                        DatePicker("Effective Date", selection: $date, in: editor.earliestDate..., displayedComponents: [.date])
                    }
                } footer: {
                    if editor.isBase {
                        Text("The pack price on the day you quit. It applies until your first price change.")
                    } else {
                        Text("The new price applies from this date. Earlier days keep the old price.")
                    }
                }

                if let previous = editor.previousPrice {
                    Section {
                        LabeledContent("Previous Price") {
                            Text(previous, format: .currency(code: currencyCode))
                                .monospacedDigit()
                        }
                        if let change {
                            LabeledContent("Change") {
                                Text(change, format: .percent.precision(.fractionLength(0...1)).sign(strategy: .always()))
                                    .monospacedDigit()
                            }
                        }
                    }
                }

                if editor.canDelete {
                    Section {
                        Button(role: .destructive, action: onDelete) {
                            Label("Delete This Entry", systemImage: "trash")
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: onCancel)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(editor.entry == nil ? LocalizedStringKey("Add") : LocalizedStringKey("Save")) {
                        onSave(price, date)
                    }
                    .disabled(price <= 0)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}
