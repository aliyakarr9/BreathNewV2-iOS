import SwiftUI

struct HealthInfoView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("Important") {
                    Text("BreathNew is not a medical device and does not give medical advice. Talk to your doctor about quitting smoking and about your health.")
                }

                Section("Recovery Percentage") {
                    Text("The percentage on the Dashboard is an estimate of your progress through your first smoke-free year. It is not a measurement of your lungs or your health.")
                }

                Section {
                    ForEach(HealthSource.all) { source in
                        Link(destination: source.url) {
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(source.organization)
                                        .font(.body)
                                        .foregroundStyle(.primary)
                                    Text(source.title)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Image(systemName: "arrow.up.right")
                                    .font(.footnote.weight(.semibold))
                                    .foregroundStyle(Color.primaryGreen)
                                    .accessibilityHidden(true)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                } header: {
                    Text("Sources")
                } footer: {
                    Text("The health timeline shows average changes reported by these organizations. Timing differs from person to person.")
                }
            }
            .navigationTitle("Health Information")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
