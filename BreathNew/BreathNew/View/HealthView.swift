import SwiftUI

struct HealthView: View {
    @StateObject private var viewModel = HealthViewModel()

    var body: some View {
        NavigationStack {
            List(viewModel.milestones) { milestone in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        // DÜZELTME 1: Başlığı çeviri anahtarı olarak işaretledik
                        Text(LocalizedStringKey(milestone.title))
                            .font(.headline)
                        
                        Spacer()
                        
                        if milestone.isCompleted {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.primaryGreen)
                        }
                    }

                    // DÜZELTME 2: Açıklamayı çeviri anahtarı olarak işaretledik
                    Text(LocalizedStringKey(milestone.description))
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    // --- Senin eklediğin İlerleme Çubuğu ve Yüzdelik Kısım ---
                    HStack {
                        ProgressView(value: milestone.progress)
                            .accentColor(.primaryGreen)
                       
                        // Yüzdelik yazı (Örn: %50)
                        Text(String(format: "%%%.0f", milestone.progress * 100))
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
    }
}
