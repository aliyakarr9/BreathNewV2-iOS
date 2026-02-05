import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @EnvironmentObject var languageManager: LanguageManager
    @State private var showingResetAlert = false
    
    // YENİ: Seçilen para birimini hafızada tutuyoruz (Varsayılan: TRY)
    @AppStorage("currencyCode") private var currencyCode = "TRY"

    var body: some View {
        NavigationStack {
            Form {
                // --- DİL SEÇİMİ ---
                Section(header: Text("Language")) {
                    Picker("Language", selection: $languageManager.selectedLanguage) {
                        Text("English 🇬🇧").tag(LanguageManager.english)
                        Text("Türkçe 🇹🇷").tag(LanguageManager.turkish)
                    }
                }
                
                // --- YENİ: PARA BİRİMİ SEÇİMİ ---
                Section(header: Text("Currency")) {
                    Picker("Select Currency", selection: $currencyCode) {
                        Text("Türk Lirası (₺)").tag("TRY")
                        Text("US Dollar ($)").tag("USD")
                        Text("Euro (€)").tag("EUR")
                        Text("British Pound (£)").tag("GBP")
                    }
                }

                // --- BİLGİLERİM ---
                Section(header: Text("My Info")) {
                    DatePicker("Quit Date", selection: $viewModel.userData.quitDate, displayedComponents: [.date, .hourAndMinute])
                    
                    Stepper("Cigarettes/Day: \(viewModel.userData.cigarettesPerDay)", value: $viewModel.userData.cigarettesPerDay, in: 0...100)
                    
                    Stepper("Pack Size: \(viewModel.userData.packSize)", value: $viewModel.userData.packSize, in: 1...50)
                    
                    // Fiyat formatını "currencyCode" değişkenine bağladık
                    TextField("Pack Price", value: $viewModel.userData.packPrice, format: .currency(code: currencyCode))
                        .keyboardType(.decimalPad)
                }

                // --- TERCİHLER ---
                Section(header: Text("Preferences")) {
                    Toggle("Notifications", isOn: $viewModel.notificationsEnabled)
                }

                // --- BUTONLAR ---
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
