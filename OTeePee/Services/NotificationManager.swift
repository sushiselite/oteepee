import Foundation
import UserNotifications
import AppKit

class NotificationManager: ObservableObject {
    @Published var notificationCount = 0
    @Published var notificationsEnabled = true
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    init() {
        checkNotificationPermissions()
    }
    
    func showOTPNotification(otp: String, from sender: String) {
        guard notificationsEnabled else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "OTP Detected & Copied"
        content.body = "Code: \(otp)\nFrom: \(sender)"
        content.sound = .default
        content.categoryIdentifier = "OTP_NOTIFICATION"
        
        // Add custom actions
        content.userInfo = ["otp": otp, "sender": sender]
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil // Show immediately
        )
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Failed to show notification: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.notificationCount += 1
                }
            }
        }
    }
    
    func showPermissionRequiredNotification() {
        let content = UNMutableNotificationContent()
        content.title = "OTeePee - Permissions Required"
        content.body = "Grant Full Disk Access to monitor iMessage for OTP codes"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "permission_required",
            content: content,
            trigger: nil
        )
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Failed to show permission notification: \(error)")
            }
        }
    }
    
    func showAppStartedNotification() {
        let content = UNMutableNotificationContent()
        content.title = "OTeePee Started"
        content.body = "Now monitoring for OTP codes in iMessage"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "app_started",
            content: content,
            trigger: nil
        )
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Failed to show start notification: \(error)")
            }
        }
    }
    
    private func checkNotificationPermissions() {
        notificationCenter.getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.notificationsEnabled = settings.authorizationStatus == .authorized
                print("Notification permission status: \(settings.authorizationStatus.rawValue)")
            }
        }
    }
    
    func requestNotificationPermissions() {
        print("Requesting notification permissions...")
        
        // First check current status
        notificationCenter.getNotificationSettings { settings in
            print("Current notification status: \(settings.authorizationStatus)")
            
            if settings.authorizationStatus == .notDetermined {
                // Request permissions for the first time
                self.notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    DispatchQueue.main.async {
                        self.notificationsEnabled = granted
                        print("Notification permissions granted: \(granted)")
                    }
                    
                    if let error = error {
                        print("Notification permission error: \(error)")
                    } else if granted {
                        // Set up notification categories after permissions are granted
                        self.setupNotificationCategories()
                    }
                }
            } else if settings.authorizationStatus == .denied {
                // User previously denied, need to open System Settings
                print("Notifications previously denied - opening System Settings")
                DispatchQueue.main.async {
                    if let url = URL(string: "x-apple.systempreferences:com.apple.preference.notifications") {
                        NSWorkspace.shared.open(url)
                    }
                }
            } else {
                // Already authorized
                DispatchQueue.main.async {
                    self.notificationsEnabled = true
                    print("Notifications already authorized")
                }
            }
        }
    }
    
    func requestNotificationPermissions(completion: @escaping (Bool) -> Void) {
        print("Requesting notification permissions with completion...")
        
        // First check current status
        notificationCenter.getNotificationSettings { settings in
            print("Current notification status: \(settings.authorizationStatus)")
            
            if settings.authorizationStatus == .notDetermined {
                // Request permissions for the first time
                self.notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    DispatchQueue.main.async {
                        self.notificationsEnabled = granted
                        completion(granted)
                        print("Notification permissions granted: \(granted)")
                    }
                    
                    if let error = error {
                        print("Notification permission error: \(error)")
                    } else if granted {
                        // Set up notification categories after permissions are granted
                        self.setupNotificationCategories()
                    }
                }
            } else if settings.authorizationStatus == .denied {
                // User previously denied, need to open System Settings
                print("Notifications previously denied - opening System Settings")
                DispatchQueue.main.async {
                    if let url = URL(string: "x-apple.systempreferences:com.apple.preference.notifications") {
                        NSWorkspace.shared.open(url)
                    }
                    completion(false)
                }
            } else {
                // Already authorized
                let authorized = settings.authorizationStatus == .authorized
                DispatchQueue.main.async {
                    self.notificationsEnabled = authorized
                    completion(authorized)
                    print("Notifications already authorized: \(authorized)")
                }
            }
        }
    }
    
    func checkNotificationPermissions(completion: @escaping (Bool) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            let granted = settings.authorizationStatus == .authorized
            DispatchQueue.main.async {
                self.notificationsEnabled = granted
                completion(granted)
            }
        }
    }
    
    func setupNotificationCategories() {
        // Define custom actions for OTP notifications
        let copyAction = UNNotificationAction(
            identifier: "COPY_ACTION",
            title: "Copy Again",
            options: []
        )
        
        let category = UNNotificationCategory(
            identifier: "OTP_NOTIFICATION",
            actions: [copyAction],
            intentIdentifiers: [],
            options: []
        )
        
        notificationCenter.setNotificationCategories([category])
    }
    
    func resetStatistics() {
        DispatchQueue.main.async {
            self.notificationCount = 0
        }
        print("Notification statistics reset")
    }
} 