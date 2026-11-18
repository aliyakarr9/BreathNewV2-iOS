import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    TimerCard(components: viewModel.timeElapsed)

                    LungHealthCard(progress: viewModel.lungHealthProgress, daysElapsed: viewModel.daysElapsed, color: .primaryGreen)

                    HStack(spacing: 16) {
                        StatCard(
                            title: "Money Saved",
                            value: viewModel.formattedMoney,
                            icon: "banknote.fill",
                            color: .primaryGreen
                        )

                        StatCard(
                            title: "Not Smoked",
                            value: viewModel.cigarettesNotSmoked.formatted(.number.precision(.fractionLength(0))),
                            icon: "smoke.fill",
                            color: .gray
                        )
                    }

                    StatCard(
                        title: "Life Regained",
                        value: viewModel.formattedLifeRegained,
                        icon: "heart.fill",
                        color: .red
                    )
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .navigationTitle("Dashboard")
            .background(Color.appBackground)
        }
    }
}

struct TimerCard: View {
    let components: DateComponents

    private var units: [(value: Int, label: String)] {
        let all: [(value: Int, label: String)] = [
            (components.year ?? 0, "Yr"),
            (components.month ?? 0, "Mo"),
            (components.day ?? 0, "Day"),
            (components.hour ?? 0, "Hr"),
            (components.minute ?? 0, "Min"),
            (components.second ?? 0, "Sec")
        ]
        let firstUsed = all.firstIndex { $0.value > 0 } ?? 3
        return Array(all[min(firstUsed, 3)...])
    }

    var body: some View {
        VStack(spacing: 14) {
            Text("Smoke Free Duration")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 0) {
                ForEach(Array(units.enumerated()), id: \.element.label) { index, unit in
                    if index > 0 {
                        Divider()
                            .frame(height: 30)
                    }
                    TimeUnit(value: unit.value, unit: unit.label)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .card()
        .accessibilityElement(children: .combine)
    }
}

struct TimeUnit: View {
    let value: Int
    let unit: String

    var body: some View {
        VStack(spacing: 2) {
            Text("\(value)")
                .font(.system(.title, design: .rounded, weight: .bold))
                .monospacedDigit()
                .contentTransition(.numericText())
                .animation(.default, value: value)
            Text(LocalizedStringKey(unit))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

struct LungHealthCard: View {
    let progress: Double
    let daysElapsed: Double
    let color: Color

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var animatedProgress: Double = 0.0
    @State private var isBreathing: Bool = false
    @State private var showingInfo = false

    private let ringSize: CGFloat = 190
    private let ringWidth: CGFloat = 10

    private var fillGradient: LinearGradient {
        LinearGradient(
            colors: [color.opacity(0.6), color],
            startPoint: .bottom,
            endPoint: .top
        )
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("Health Recovery")
                .font(.headline)

            ZStack {
                Circle()
                    .stroke(Color.trackFill, lineWidth: ringWidth)

                Circle()
                    .trim(from: 0, to: animatedProgress)
                    .stroke(color, style: StrokeStyle(lineWidth: ringWidth, lineCap: .round))
                    .rotationEffect(.degrees(-90))

                lungs
                    .scaleEffect(isBreathing ? 1.04 : 0.97)
            }
            .frame(width: ringSize, height: ringSize)
            .padding(.vertical, 4)

            VStack(spacing: 6) {
                Text(animatedProgress, format: .percent.precision(.fractionLength(0)))
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(color)
                    .contentTransition(.numericText())

                Text(motivationalMessage)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .card()
        .overlay(alignment: .topTrailing) {
            Button {
                showingInfo = true
            } label: {
                Image(systemName: "info.circle")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Health Information")
            .padding(6)
        }
        .sheet(isPresented: $showingInfo) {
            HealthInfoView()
        }
        .onAppear {
            withAnimation(.spring(response: 1.2, dampingFraction: 0.85)) {
                animatedProgress = progress
            }
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                isBreathing = true
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(.spring(response: 0.8, dampingFraction: 0.85)) {
                animatedProgress = newValue
            }
        }
    }

    private var lungs: some View {
        let lungSize = ringSize * 0.5
        let symbol = Image(systemName: "lungs.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: lungSize)

        return ZStack {
            symbol
                .foregroundStyle(Color.trackFill)

            symbol
                .foregroundStyle(color)
                .opacity(isBreathing ? 0.22 : 0.08)

            symbol
                .foregroundStyle(fillGradient)
                .mask(alignment: .bottom) {
                    Rectangle()
                        .frame(height: lungSize * animatedProgress)
                }
        }
        .accessibilityHidden(true)
    }

    private var motivationalMessage: String {
        let isTurkish = UserDefaults.standard.string(forKey: "language") == "tr"
        return MotivationalMessages.message(forDaysElapsed: daysElapsed, isTurkish: isTurkish)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
                .frame(height: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .monospacedDigit()
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)

                Text(LocalizedStringKey(title))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .card(padding: 18)
        .accessibilityElement(children: .combine)
    }
}
