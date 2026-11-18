import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
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

                Section(header: Text("My Info")) {
                    DatePicker("Quit Date", selection: $viewModel.userData.quitDate, displayedComponents: [.date, .hourAndMinute])

                    Stepper("Cigarettes/Day: \(viewModel.userData.cigarettesPerDay)", value: $viewModel.userData.cigarettesPerDay, in: 0...100)

                    Stepper("Pack Size: \(viewModel.userData.packSize)", value: $viewModel.userData.packSize, in: 1...50)
                }

                Section(header: Text("Update Price")) {
                    DatePicker("Price Date", selection: $viewModel.newPriceDate, displayedComponents: [.date])

                    TextField("New Price", value: $viewModel.newPrice, format: .currency(code: viewModel.currencyCode))
                        .keyboardType(.decimalPad)

                    Button(action: {
                        viewModel.addPriceUpdate()
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Update Price")
                        }
                        .foregroundColor(.primaryGreen)
                    }
                    .disabled(viewModel.newPrice <= 0)
                }

                if !viewModel.sortedPriceHistory.isEmpty {
                    Section(header: Text("Price History")) {
                        ForEach(viewModel.sortedPriceHistory) { entry in
                            Button(action: {
                                viewModel.startEditing(entry)
                            }) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(entry.date, style: .date)
                                            .font(.subheadline)
                                        Text(entry.date, style: .time)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Text(formatPrice(entry.price))
                                        .font(.headline)
                                        .foregroundColor(.primaryGreen)
                                    Image(systemName: "pencil")
                                        .foregroundColor(.secondary)
                                        .font(.caption)
                                }
                            }
                            .buttonStyle(.plain)
                            .contextMenu {
                                Button {
                                    viewModel.startEditing(entry)
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                Button(role: .destructive) {
                                    viewModel.deleteEntry(entry)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                        .onDelete(perform: viewModel.removePriceEntry)
                    }
                }

                Section(header: Text("Preferences")) {
                    Toggle("Notifications", isOn: $viewModel.notificationsEnabled)
                }

                Section {
                    Button(action: {
                        viewModel.saveChanges()
                    }) {
                        Text("Save Changes")
                    }

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
            .sheet(isPresented: $viewModel.isEditingPrice) {
                NavigationStack {
                    Form {
                        Section(header: Text("Edit Price")) {
                            DatePicker("Price Date", selection: $viewModel.editDate, displayedComponents: [.date])

                            TextField("Price", value: $viewModel.editPrice, format: .currency(code: viewModel.currencyCode))
                                .keyboardType(.decimalPad)
                        }

                        Section {
                            Button(role: .destructive, action: {
                                viewModel.deleteEditingEntry()
                            }) {
                                HStack {
                                    Image(systemName: "trash")
                                    Text("Delete This Entry")
                                }
                                .foregroundColor(.red)
                            }
                        }
                    }
                    .navigationTitle("Edit Price Entry")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                viewModel.cancelEdit()
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                viewModel.saveEdit()
                            }
                            .disabled(viewModel.editPrice <= 0)
                        }
                    }
                }
                .presentationDetents([.medium])
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
