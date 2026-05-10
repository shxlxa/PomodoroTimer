import UserNotifications
#if os(iOS)
import UIKit
#endif

final class NotificationService {
    static let shared = NotificationService()

    private init() {}

    private var isAvailable: Bool {
        #if os(macOS)
        return Bundle.main.bundleIdentifier != nil
        #else
        return true
        #endif
    }

    func requestAuthorization() {
        guard isAvailable else { return }
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            if granted {
                #if os(iOS)
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                #endif
            }
        }
    }

    func sendNotification(title: String, body: String) {
        guard isAvailable else { return }
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request)
    }
}
