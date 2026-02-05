import SwiftUI

@main
struct BreathNewApp: App {
    @StateObject private var languageManager = LanguageManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(languageManager)
                .environment(\.locale, .init(identifier: languageManager.selectedLanguage))
        }
    }
}
