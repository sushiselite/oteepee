import SwiftUI
import UserNotifications

@main
struct OTeePeeApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var messageMonitor = MessageMonitor()
    @StateObject private var notificationManager = NotificationManager()
    @StateObject private var clipboardManager = ClipboardManager()
    @State private var showingOnboarding = false
    
    var body: some Scene {
        MenuBarExtra("OTeePee", systemImage: "lock.shield") {
            MenuBarView()
                .environmentObject(messageMonitor)
                .environmentObject(notificationManager)
                .environmentObject(clipboardManager)
        }
        .menuBarExtraStyle(.window)
        
        // Note: Onboarding and Settings windows are now managed by WindowManager
        // This keeps the app structure clean while allowing better control
    }
} 