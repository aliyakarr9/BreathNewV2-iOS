import SwiftUI
import Combine

class LanguageManager: ObservableObject {
    @AppStorage("language") var selectedLanguage: String = "en" {
        willSet {
            objectWillChange.send()
        }
    }

    static let english = "en"
    static let turkish = "tr"
}
