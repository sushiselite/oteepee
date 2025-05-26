import Cocoa
import UserNotifications
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    
    // Store references to managers for window creation
    var messageMonitor: MessageMonitor?
    var notificationManager: NotificationManager?
    var clipboardManager: ClipboardManager?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Check if this is the first launch
        let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        
        if !hasCompletedOnboarding {
            // Show onboarding for first-time users
            showOnboardingWindow()
            // Keep app in dock during onboarding
            NSApp.setActivationPolicy(.regular)
        } else {
            // Hide app from dock (menu bar only) for returning users
            NSApp.setActivationPolicy(.accessory)
            
            // Check for required permissions for returning users
            checkPermissions()
        }
        
        // Request notification permissions (for both new and returning users)
        requestNotificationPermissions()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Clean up any resources if needed
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        // Keep app running even when all windows are closed (menu bar app)
        print("Last window closed - keeping app running as menu bar app")
        return false
    }
    
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        // Only allow termination if explicitly requested (e.g., via Quit button)
        print("App termination requested")
        return .terminateNow
    }
    
    private func requestNotificationPermissions() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permissions granted")
            } else {
                print("Notification permissions denied")
            }
        }
    }
    
    private func showOnboardingWindow() {
        // We need to get references to the managers from the app
        // This is a bit tricky in SwiftUI, so we'll use a delay to allow the app to initialize
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // For now, let's create temporary managers for onboarding
            // In a real implementation, you'd want to share these with the main app
            let messageMonitor = MessageMonitor()
            let notificationManager = NotificationManager()
            let clipboardManager = ClipboardManager()
            
            WindowManager.shared.showOnboardingWindow(
                messageMonitor: messageMonitor,
                notificationManager: notificationManager,
                clipboardManager: clipboardManager
            )
        }
    }
    
    private func checkPermissions() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if !FilePermissions.hasFullDiskAccess() {
                self.showPermissionsAlert()
            }
        }
    }
    
    private func showPermissionsAlert() {
        let alert = NSAlert()
        alert.messageText = "Permissions Required"
        alert.informativeText = "OTeePee needs Full Disk Access to read iMessage. Please grant this permission in System Preferences > Security & Privacy > Privacy > Full Disk Access."
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Open System Preferences")
        alert.addButton(withTitle: "Later")
        
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles")!)
        }
    }
} 