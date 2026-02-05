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

                Section(header: Text("My Info")) {
                    DatePicker("Quit Date", selection: $viewModel.userData.quitDate, displayedComponents: [.date, .hourAndMinute])
                    Stepper("Cigarettes/Day: \(viewModel.userData.cigarettesPerDay)", value: $viewModel.userData.cigarettesPerDay, in: 0...100)
                    Stepper("Pack Size: \(viewModel.userData.packSize)", value: $viewModel.userData.packSize, in: 1...50)
                    TextField("Pack Price", value: $viewModel.userData.packPrice, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
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
        }
    }
}
