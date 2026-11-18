import Foundation
import Combine
import UserNotifications

final class NotificationManager: NSObject, ObservableObject {
    static let shared = NotificationManager()

    private let enabledKey = "breathnew_notifications_enabled"
    private let center = UNUserNotificationCenter.current()
    private var cancellables = Set<AnyCancellable>()
    private var scheduleGeneration = 0

    @Published private(set) var isEnabled: Bool
    @Published var permissionDenied = false

    private override init() {
        isEnabled = UserDefaults.standard.bool(forKey: enabledKey)
        super.init()
        center.delegate = self

        DataManager.shared.$userData
            .map(\.quitDate)
            .removeDuplicates()
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                Task { await self?.refresh() }
            }
            .store(in: &cancellables)
    }

    func setEnabled(_ enabled: Bool) async {
        guard enabled else {
            store(false)
            cancelAll()
            return
        }

        let granted = (try? await center.requestAuthorization(options: [.alert, .sound])) ?? false
        guard granted else {
            store(false)
            permissionDenied = true
            return
        }

        store(true)
        await schedule()
    }

    func refresh() async {
        guard isEnabled else { return }

        let status = await center.notificationSettings().authorizationStatus
        guard status == .authorized || status == .provisional else {
            store(false)
            cancelAll()
            return
        }
        await schedule()
    }

    private func schedule() async {
        scheduleGeneration += 1
        let generation = scheduleGeneration
        center.removeAllPendingNotificationRequests()

        guard DataManager.shared.isOnboardingCompleted else { return }
        let quitDate = DataManager.shared.userData.quitDate
        let now = Date()

        for moment in Self.moments {
            let interval = quitDate.addingTimeInterval(moment.duration).timeIntervalSince(now)
            guard interval > 1 else { continue }

            let content = UNMutableNotificationContent()
            content.title = String(format: localized("%@ smoke-free"), localized(moment.title))
            content.body = [
                moment.healthNote.map(localized),
                moment.earnsBadge ? localized("You earned a new badge.") : nil
            ]
            .compactMap { $0 }
            .joined(separator: " ")
            content.sound = .default

            let request = UNNotificationRequest(
                identifier: "milestone-\(Int(moment.duration))",
                content: content,
                trigger: UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
            )

            guard generation == scheduleGeneration else { return }
            try? await center.add(request)
        }
    }

    private func cancelAll() {
        scheduleGeneration += 1
        center.removeAllPendingNotificationRequests()
    }

    private func store(_ enabled: Bool) {
        isEnabled = enabled
        UserDefaults.standard.set(enabled, forKey: enabledKey)
    }

    private func localized(_ key: String) -> String {
        let language = UserDefaults.standard.string(forKey: "language") ?? LanguageManager.english
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
              let bundle = Bundle(path: path) else { return key }
        return bundle.localizedString(forKey: key, value: key, table: nil)
    }

    private struct Moment {
        let duration: TimeInterval
        let title: String
        let healthNote: String?
        let earnsBadge: Bool
    }

    private static let moments: [Moment] = {
        let badges = Dictionary(Badge.all.map { ($0.duration, $0) }, uniquingKeysWith: { first, _ in first })
        let milestones = Dictionary(HealthMilestone.all.map { ($0.duration, $0) }, uniquingKeysWith: { first, _ in first })

        return Set(badges.keys).union(milestones.keys).sorted().map { duration in
            Moment(
                duration: duration,
                title: milestones[duration]?.title ?? badges[duration]?.title ?? "",
                healthNote: milestones[duration]?.description,
                earnsBadge: badges[duration] != nil
            )
        }
    }()
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .list, .sound]
    }
}
