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
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }

            HealthView()
                .tabItem {
                    Label("Health", systemImage: "heart.fill")
                }

            AchievementsView()
                .tabItem {
                    Label("Badges", systemImage: "rosette")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .accentColor(.primaryGreen)
    }
}
