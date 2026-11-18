import SwiftUI

struct PriceField: View {
    @Binding var value: Double
    let currencyCode: String

    var focusOnAppear = false

    @State private var text: String
    @FocusState private var isFocused: Bool

    init(value: Binding<Double>, currencyCode: String, focusOnAppear: Bool = false) {
        self._value = value
        self.currencyCode = currencyCode
        self.focusOnAppear = focusOnAppear
        self._text = State(initialValue: Self.text(for: value.wrappedValue))
    }

    var body: some View {
        HStack(spacing: 6) {
            TextField("0", text: $text)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .monospacedDigit()
                .focused($isFocused)
                .onAppear {
                    if focusOnAppear { isFocused = true }
                }
                .onChange(of: text) { _, newText in
                    value = Self.parse(newText) ?? 0
                }

            Text(Self.symbol(for: currencyCode))
                .foregroundStyle(.secondary)
        }
    }

    static func parse(_ text: String) -> Double? {
        let cleaned = text
            .replacingOccurrences(of: ",", with: ".")
            .filter { $0.isNumber || $0 == "." }
        guard let number = Double(cleaned), number > 0, number.isFinite else { return nil }
        return number
    }

    static func text(for price: Double) -> String {
        guard price > 0 else { return "" }
        return price.formatted(.number.precision(.fractionLength(0...2)).grouping(.never))
    }

    static func symbol(for currencyCode: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        return formatter.currencySymbol ?? currencyCode
    }
}
