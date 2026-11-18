import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    TimerCard(components: viewModel.timeElapsed, color: .primaryGreen)
                        .padding(.horizontal)

                    LungHealthCard(progress: viewModel.lungHealthProgress, color: .primaryGreen)
                        .padding(.horizontal)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        StatCard(
                            title: "Money Saved",
                            value: viewModel.formattedMoney,
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
                            value: viewModel.formattedLifeRegained,
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
            Text(LocalizedStringKey(unit))
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

                GeometryReader { geometry in
                    let lungSize = min(geometry.size.width, geometry.size.height) * 0.55
                    ZStack {
                        Image(systemName: "lungs.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: lungSize)
                            .foregroundColor(Color.gray.opacity(0.2))

                        VStack {
                            Spacer()
                            Rectangle()
                                .frame(height: lungSize * CGFloat(progress))
                                .foregroundColor(color)
                        }
                        .frame(height: lungSize)
                        .mask(
                            Image(systemName: "lungs.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: lungSize)
                        )
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(height: 180)
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

            Text(LocalizedStringKey(title))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
