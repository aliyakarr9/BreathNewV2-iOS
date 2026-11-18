import SwiftUI

extension Color {
    static let primaryGreen = Color(red: 46/255, green: 204/255, blue: 113/255)

    static let badgeGold = Color(red: 240/255, green: 173/255, blue: 30/255)

    static let appBackground = Color(.systemGroupedBackground)
    static let cardBackground = Color(.secondarySystemGroupedBackground)

    static let trackFill = Color.primary.opacity(0.07)
}

extension View {
    func card(padding: CGFloat = 20) -> some View {
        self
            .padding(padding)
            .frame(maxWidth: .infinity)
            .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}
