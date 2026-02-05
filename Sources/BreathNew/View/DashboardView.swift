import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Timer Card
                    TimerCard(components: viewModel.timeElapsed, color: .primaryGreen)
                        .padding(.horizontal)

                    // Lung Health Animation
                    LungHealthCard(progress: viewModel.lungHealthProgress, color: .primaryGreen)
                        .padding(.horizontal)

                    // Stats Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        StatCard(
                            title: "Money Saved",
                            value: formatMoney(viewModel.moneySaved),
                            icon: "banknote",
                            color: .primaryGreen
                        )

                        StatCard(
                            title: "Not Smoked",
                            value: String(format: "%.0f", viewModel.cigarettesNotSmoked),
                            icon: "smoke.fill",
                            color: .gray
                        )

                        StatCard(
                            title: "Life Regained",
                            value: formatLifeRegained(viewModel.lifeRegained),
                            icon: "heart.fill",
                            color: .red
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Dashboard")
            .background(Color(UIColor.systemGroupedBackground))
        }
    }

    func formatMoney(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = Locale.current.currency?.identifier ?? "USD"
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }

    func formatLifeRegained(_ seconds: TimeInterval) -> String {
        let days = Int(seconds) / 86400
        let hours = (Int(seconds) % 86400) / 3600
        let minutes = (Int(seconds) % 3600) / 60

        if days > 0 {
            return "\(days)d \(hours)h"
        } else if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

struct TimerCard: View {
    let components: DateComponents
    let color: Color

    var body: some View {
        VStack(spacing: 10) {
            Text("Smoke Free Duration")
                .font(.subheadline)
                .foregroundColor(.secondary)

            HStack(spacing: 15) {
                TimeUnit(value: components.year ?? 0, unit: "Yr")
                TimeUnit(value: components.month ?? 0, unit: "Mo")
                TimeUnit(value: components.day ?? 0, unit: "Day")
                TimeUnit(value: components.hour ?? 0, unit: "Hr")
                TimeUnit(value: components.minute ?? 0, unit: "Min")
                TimeUnit(value: components.second ?? 0, unit: "Sec")
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct TimeUnit: View {
    let value: Int
    let unit: String

    var body: some View {
        VStack {
            Text("\(value)")
                .font(.title2)
                .bold()
            Text(unit)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}

struct LungHealthCard: View {
    let progress: Double
    let color: Color

    var body: some View {
        VStack {
            Text("Health Recovery")
                .font(.headline)

            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.1), lineWidth: 10)
                    .frame(height: 180)

                Image(systemName: "lungs.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
                    .foregroundColor(Color.gray.opacity(0.2))
                    .overlay(
                        GeometryReader { geometry in
                            VStack {
                                Spacer()
                                Rectangle()
                                    .frame(height: geometry.size.height * CGFloat(progress))
                                    .foregroundColor(color)
                            }
                            .mask(
                                Image(systemName: "lungs.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 100)
                            )
                        }
                    )
            }
            .padding()

            Text("\(Int(progress * 100))%")
                .font(.title)
                .bold()
                .foregroundColor(color)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Spacer()
            }

            Text(value)
                .font(.title2)
                .bold()
                .minimumScaleFactor(0.5)
                .lineLimit(1)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
