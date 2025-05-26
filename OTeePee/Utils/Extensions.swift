import Foundation
import SwiftUI
import AppKit

// MARK: - String Extensions
extension String {
    var isValidOTP: Bool {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check length
        guard trimmed.count >= 3 && trimmed.count <= 8 else {
            return false
        }
        
        // Check for at least one digit
        guard trimmed.rangeOfCharacter(from: .decimalDigits) != nil else {
            return false
        }
        
        // Check for valid characters (alphanumeric only)
        let allowedCharacters = CharacterSet.alphanumerics
        guard trimmed.rangeOfCharacter(from: allowedCharacters.inverted) == nil else {
            return false
        }
        
        return true
    }
    
    func containsOTPKeywords() -> Bool {
        let keywords = ["verification", "verify", "code", "pin", "otp", "security", "access",
                       "authentication", "confirm", "temporary", "login", "signin", "account",
                       "password", "passcode", "unlock", "activate", "validate"]
        
        let lowercased = self.lowercased()
        return keywords.contains { keyword in
            lowercased.contains(keyword)
        }
    }
}

// MARK: - Date Extensions
extension Date {
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}

// MARK: - Color Extensions
extension Color {
    static let otpGreen = Color.green.opacity(0.8)
    static let otpBlue = Color.blue.opacity(0.8)
    static let otpRed = Color.red.opacity(0.8)
    static let otpGray = Color.gray.opacity(0.6)
    
    static let backgroundPrimary = Color(NSColor.controlBackgroundColor)
    static let backgroundSecondary = Color(NSColor.unemphasizedSelectedContentBackgroundColor)
    static let textPrimary = Color(NSColor.labelColor)
    static let textSecondary = Color(NSColor.secondaryLabelColor)
}

// MARK: - View Extensions
extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: - UserDefaults Extensions
extension UserDefaults {
    private enum Keys {
        static let isFirstLaunch = "isFirstLaunch"
        static let monitoringEnabled = "monitoringEnabled"
        static let notificationsEnabled = "notificationsEnabled"
        static let lastMessageRowID = "lastMessageRowID"
        static let otpCount = "otpCount"
    }
    
    var isFirstLaunch: Bool {
        get { !bool(forKey: Keys.isFirstLaunch) }
        set { set(!newValue, forKey: Keys.isFirstLaunch) }
    }
    
    var monitoringEnabled: Bool {
        get { bool(forKey: Keys.monitoringEnabled) }
        set { set(newValue, forKey: Keys.monitoringEnabled) }
    }
    
    var notificationsEnabled: Bool {
        get { object(forKey: Keys.notificationsEnabled) as? Bool ?? true }
        set { set(newValue, forKey: Keys.notificationsEnabled) }
    }
    
    var otpCount: Int {
        get { integer(forKey: Keys.otpCount) }
        set { set(newValue, forKey: Keys.otpCount) }
    }
}

// MARK: - NSApplication Extensions
extension NSApplication {
    func showSettingsWindow() {
        // Find and activate the settings window
        for window in windows {
            if window.title == "Settings" {
                window.makeKeyAndOrderFront(nil)
                activate(ignoringOtherApps: true)
                return
            }
        }
        // If no settings window is open, we could potentially open one here
        // For now, we'll just activate the app
        activate(ignoringOtherApps: true)
    }
} 