import SwiftUI

struct ContentView: View {
    @ObservedObject private var dataManager = DataManager.shared

    var body: some View {
        if dataManager.isOnboardingCompleted {
            MainTabView()
        } else {
            OnboardingView()
        }
    }
}

struct MainTabView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
                .tag(0)

            HealthView()
                .tabItem {
                    Label("Health", systemImage: "heart.fill")
                }
                .tag(1)

            AchievementsView()
                .tabItem {
                    Label("Badges", systemImage: "rosette")
                }
                .tag(2)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(3)
        }
        .tint(.primaryGreen)
    }
}
