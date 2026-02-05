# Localization Guide for BreathNew

This guide explains how to add multi-language support (English and Turkish) using the modern String Catalog (`.xcstrings`) format.

## 1. Create the String Catalog

1.  Open the project in Xcode.
2.  Go to **File > New > File...** (or press `Cmd + N`).
3.  Search for **String Catalog**.
4.  Name the file `Localizable` and click **Create**.
5.  In the Project Navigator, select the newly created `Localizable.xcstrings` file.
6.  In the Inspector panel (right side), under the **Localization** section, click the **+** button and add **Turkish (tr)**. English (en) should be there by default.

## 2. Refactor Hardcoded Strings

SwiftUI works seamlessly with String Catalogs. When you use `Text("Some String")`, Xcode automatically detects "Some String" as a key.

### Example: Refactoring "Dashboard"

**Before (Hardcoded):**
```swift
Text("Dashboard")
```

**After (Localized):**
You don't need to change the code! Xcode automatically extracts "Dashboard" as a key into `Localizable.xcstrings` when you build the project.

However, if you want to be explicit or if the key differs from the value:

```swift
Text("dashboard_title", comment: "Title for the dashboard screen")
```

### 3. Translate in .xcstrings

1.  Open `Localizable.xcstrings`.
2.  You will see a list of keys (e.g., "Dashboard", "Health", "Settings").
3.  Expand the key to see columns for **English** and **Turkish**.
4.  Enter the translations:
    *   **English:** Dashboard
    *   **Turkish:** Özet (or Panel)

### 4. Dynamic Strings

For strings with variables, use String Interpolation.

**Code:**
```swift
Text("Cigarettes per Day: \(viewModel.cigarettesPerDay)")
```

**String Catalog Key:**
`Cigarettes per Day: %lld`

**Translation (Turkish):**
`Günlük Sigara Sayısı: %lld`

## Summary of Changes

*   **English (en):** Default.
*   **Turkish (tr):** Added as a supported language.
*   `LanguageManager` handles the user's preference and forces the app to update via `.environment(\.locale, ...)`.
