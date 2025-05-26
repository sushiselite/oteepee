import SwiftUI
import AppKit

class WindowManager: ObservableObject {
    static let shared = WindowManager()
    
    var onboardingWindow: NSWindow?
    var settingsWindow: NSWindow?
    
    private init() {}
    
    func showOnboardingWindow(
        messageMonitor: MessageMonitor,
        notificationManager: NotificationManager,
        clipboardManager: ClipboardManager
    ) {
        if onboardingWindow == nil {
            let contentView = OnboardingView {
                // Close onboarding and switch to menu bar mode
                print("Onboarding completed - switching to menu bar mode")
                self.closeOnboardingWindow()
                
                // Ensure app stays running in accessory mode
                DispatchQueue.main.async {
                    NSApp.setActivationPolicy(.accessory)
                    print("App switched to accessory mode")
                }
            }
            .environmentObject(messageMonitor)
            .environmentObject(notificationManager)
            .environmentObject(clipboardManager)
            
            let hostingController = NSHostingController(rootView: contentView)
            
            onboardingWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 700, height: 500),
                styleMask: [.titled, .closable],
                backing: .buffered,
                defer: false
            )
            
            onboardingWindow?.contentViewController = hostingController
            onboardingWindow?.title = "Welcome to OTeePee"
            onboardingWindow?.center()
            onboardingWindow?.isReleasedWhenClosed = false
            onboardingWindow?.delegate = WindowManagerDelegate.shared
            
            // Make window non-resizable to prevent layout issues
            onboardingWindow?.minSize = NSSize(width: 700, height: 500)
            onboardingWindow?.maxSize = NSSize(width: 700, height: 500)
        }
        
        onboardingWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func closeOnboardingWindow() {
        print("Closing onboarding window")
        onboardingWindow?.close()
        onboardingWindow = nil
        
        // Ensure app doesn't quit after closing onboarding
        DispatchQueue.main.async {
            NSApp.setActivationPolicy(.accessory)
        }
    }
    
    func showSettingsWindow(
        messageMonitor: MessageMonitor,
        notificationManager: NotificationManager,
        clipboardManager: ClipboardManager
    ) {
        if settingsWindow == nil {
            let contentView = ContentView()
                .environmentObject(messageMonitor)
                .environmentObject(notificationManager)
                .environmentObject(clipboardManager)
            
            let hostingController = NSHostingController(rootView: contentView)
            
            settingsWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 600, height: 400),
                styleMask: [.titled, .closable, .resizable],
                backing: .buffered,
                defer: false
            )
            
            settingsWindow?.contentViewController = hostingController
            settingsWindow?.title = "Settings"
            settingsWindow?.center()
            settingsWindow?.isReleasedWhenClosed = false
            settingsWindow?.delegate = WindowManagerDelegate.shared
        }
        
        settingsWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func closeSettingsWindow() {
        print("Closing settings window")
        settingsWindow?.close()
        settingsWindow = nil
        
        // Ensure app doesn't quit after closing settings
        DispatchQueue.main.async {
            NSApp.setActivationPolicy(.accessory)
        }
    }
}

// MARK: - Window Delegate
class WindowManagerDelegate: NSObject, NSWindowDelegate {
    static let shared = WindowManagerDelegate()
    
    func windowWillClose(_ notification: Notification) {
        guard let window = notification.object as? NSWindow else { return }
        
        print("Window will close: \(window.title)")
        
        if window.title == "Welcome to OTeePee" {
            // Don't call closeOnboardingWindow here as it will cause double-close
            // Just clean up the reference
            DispatchQueue.main.async {
                WindowManager.shared.onboardingWindow = nil
                NSApp.setActivationPolicy(.accessory)
                print("Onboarding window closed - app remains in menu bar")
            }
        } else if window.title == "Settings" {
            // Don't call closeSettingsWindow here as it will cause double-close
            // Just clean up the reference
            DispatchQueue.main.async {
                WindowManager.shared.settingsWindow = nil
                NSApp.setActivationPolicy(.accessory)
                print("Settings window closed - app remains in menu bar")
            }
        }
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        print("Window should close: \(sender.title)")
        return true
    }
} 