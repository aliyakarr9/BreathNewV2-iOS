import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Quit Date")) {
                    DatePicker("Date & Time", selection: $viewModel.quitDate, displayedComponents: [.date, .hourAndMinute])
                }

                Section(header: Text("Habits")) {
                    Stepper("Cigarettes per Day: \(viewModel.cigarettesPerDay)", value: $viewModel.cigarettesPerDay, in: 1...100)
                    Stepper("Cigarettes in Pack: \(viewModel.packSize)", value: $viewModel.packSize, in: 1...50)
                    HStack {
                        Text("Pack Price")
                        Spacer()
                        TextField("Price", value: $viewModel.packPrice, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    Stepper("Time per Cigarette (min): \(viewModel.timePerCigarette)", value: $viewModel.timePerCigarette, in: 1...60)
                }

                Section {
                    Button(action: {
                        viewModel.save()
                    }) {
                        Text("Start Journey")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.primaryGreen)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .listRowInsets(EdgeInsets())
                }
                .listRowBackground(Color.clear)
            }
            .navigationTitle("Welcome")
        }
    }
}
