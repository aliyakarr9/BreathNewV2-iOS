import SwiftUI
import Combine

struct HealthView: View {
    @StateObject private var viewModel = HealthViewModel()
    @EnvironmentObject var languageManager: LanguageManager
    @State private var showingInfo = false

    private let refreshTimer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(viewModel.milestones) { milestone in
                        MilestoneRow(milestone: milestone)
                    }
                } footer: {
                    Text("These are average changes and differ from person to person. This is not medical advice.")
                }
            }
            .navigationTitle("Health Timeline")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingInfo = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .accessibilityLabel("Health Information")
                }
            }
            .sheet(isPresented: $showingInfo) {
                HealthInfoView()
            }
            .onAppear {
                viewModel.updateProgress()
            }
            .onReceive(refreshTimer) { _ in
                viewModel.updateProgress()
            }
        }
        .id(languageManager.selectedLanguage)
    }
}

private struct MilestoneRow: View {
    let milestone: HealthMilestone

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(LocalizedStringKey(milestone.title))
                    .font(.headline)

                Spacer()

                if milestone.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(Color.primaryGreen)
                        .accessibilityHidden(true)
                }
            }

            Text(LocalizedStringKey(milestone.description))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 12) {
                ProgressView(value: milestone.progress)
                    .tint(.primaryGreen)

                Text(milestone.progress, format: .percent.precision(.fractionLength(0)))
                    .font(.caption)
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
                    .frame(width: 44, alignment: .trailing)
            }
            .padding(.top, 2)
        }
        .padding(.vertical, 6)
        .accessibilityElement(children: .combine)
    }
}
