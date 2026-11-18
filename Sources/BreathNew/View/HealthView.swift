import SwiftUI

struct HealthView: View {
    @StateObject private var viewModel = HealthViewModel()
    @EnvironmentObject var languageManager: LanguageManager

    var body: some View {
        NavigationStack {
            List(viewModel.milestones) { milestone in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(LocalizedStringKey(milestone.title))
                            .font(.headline)
                        
                        Spacer()
                        
                        if milestone.isCompleted {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.primaryGreen)
                        }
                    }

                    Text(LocalizedStringKey(milestone.description))
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    HStack {
                        ProgressView(value: milestone.progress)
                            .accentColor(.primaryGreen)
                       
                        Text(String(format: "%.0f%%", milestone.progress * 100))
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(width: 40, alignment: .trailing)
                    }
                }
                .padding(.vertical, 5)
            }
            .navigationTitle("Health Timeline")
            .onAppear {
                viewModel.updateProgress()
            }
        }
        .id(languageManager.selectedLanguage)
    }
}

