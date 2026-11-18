import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(spacing: 12) {
                        Image(systemName: "lungs.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(Color.primaryGreen)
                            .accessibilityHidden(true)

                        Text("Start your smoke-free life")
                            .font(.title2.bold())
                            .multilineTextAlignment(.center)

                        Text("Tell us about your habit so we can track your recovery and your savings.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())

                Section(header: Text("Quit Date")) {
                    DatePicker("Date & Time", selection: $viewModel.quitDate, displayedComponents: [.date, .hourAndMinute])
                }

                Section {
                    Stepper("Cigarettes per Day: \(viewModel.cigarettesPerDay)", value: $viewModel.cigarettesPerDay, in: 1...100)
                    Stepper("Cigarettes in Pack: \(viewModel.packSize)", value: $viewModel.packSize, in: 1...50)
                    HStack {
                        Text("Pack Price")
                        PriceField(value: $viewModel.packPrice, currencyCode: DataManager.shared.currencyCode)
                    }
                    Stepper("Time per Cigarette (min): \(viewModel.timePerCigarette)", value: $viewModel.timePerCigarette, in: 1...60)
                } header: {
                    Text("Habits")
                } footer: {
                    Text("Enter your pack price so your savings can be calculated.")
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Welcome")
            .safeAreaInset(edge: .bottom) {
                Button {
                    viewModel.save()
                } label: {
                    Text("Start Journey")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .controlSize(.large)
                .tint(.primaryGreen)
                .disabled(viewModel.packPrice <= 0)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            }
        }
    }
}
