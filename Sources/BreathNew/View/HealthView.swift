import SwiftUI

struct HealthView: View {
    @StateObject private var viewModel = HealthViewModel()

    var body: some View {
        NavigationStack {
            List(viewModel.milestones) { milestone in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(milestone.title)
                            .font(.headline)
                        Spacer()
                        if milestone.isCompleted {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.primaryGreen)
                        }
                    }

                    Text(milestone.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    ProgressView(value: milestone.progress)
                        .accentColor(.primaryGreen)
                }
                .padding(.vertical, 5)
            }
            .navigationTitle("Health Timeline")
            .onAppear {
                viewModel.updateProgress()
            }
        }
    }
}
