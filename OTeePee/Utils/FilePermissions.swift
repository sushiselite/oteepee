import Foundation
import AppKit

class FilePermissions {
    
    static func hasFullDiskAccess() -> Bool {
        let iMessageDBPath = "\(NSHomeDirectory())/Library/Messages/chat.db"
        
        // Try to access the iMessage database
        let fileManager = FileManager.default
        
        // First check if file exists
        guard fileManager.fileExists(atPath: iMessageDBPath) else {
            print("iMessage database does not exist at path: \(iMessageDBPath)")
            return false
        }
        
        // Try to read the file to check permissions
        guard fileManager.isReadableFile(atPath: iMessageDBPath) else {
            print("Cannot read iMessage database - Full Disk Access required")
            return false
        }
        
        // Try to open the file for reading
        do {
            let fileHandle = try FileHandle(forReadingFrom: URL(fileURLWithPath: iMessageDBPath))
            fileHandle.closeFile()
            return true
        } catch {
            print("Error accessing iMessage database: \(error)")
            return false
        }
    }
    
    static func openSystemPreferences() {
        print("Opening Full Disk Access settings...")
        
        // For macOS 15+ (Sequoia), use System Settings
        if #available(macOS 15.0, *) {
            // Try multiple approaches to open the right settings panel
            let urls = [
                "x-apple.systempreferences:com.apple.privacy-preferences-extension",
                "x-apple.systempreferences:privacy",
                "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
            ]
            
            for urlString in urls {
                if let url = URL(string: urlString) {
                    NSWorkspace.shared.open(url)
                    print("Opened: \(urlString)")
                    return
                }
            }
        } else {
            // Fallback for older macOS versions
            if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles") {
                NSWorkspace.shared.open(url)
                print("Opened legacy system preferences")
            }
        }
    }
    
    static func checkPermissionStatus() -> PermissionStatus {
        let iMessageDBPath = "\(NSHomeDirectory())/Library/Messages/chat.db"
        print("Checking permissions for path: \(iMessageDBPath)")
        
        if hasFullDiskAccess() {
            print("Full Disk Access granted")
            return .granted
        } else {
            // Check if the Messages directory exists (it should on any Mac with Messages app)
            let messagesDir = "\(NSHomeDirectory())/Library/Messages"
            let fileManager = FileManager.default
            
            if fileManager.fileExists(atPath: messagesDir) {
                print("Messages directory exists, but database access denied - need Full Disk Access")
                return .denied
            } else {
                print("Messages directory not found - checking if this Mac uses iMessage")
                // Try alternative approach - see if we can at least detect the Messages app
                let messagesAppPath = "/System/Applications/Messages.app"
                if fileManager.fileExists(atPath: messagesAppPath) {
                    print("Messages app found but directory not accessible - need Full Disk Access")
                    return .denied
                } else {
                    print("Messages app not found - iMessage may not be available")
                    return .iMessageNotAvailable
                }
            }
        }
    }
}

enum PermissionStatus {
    case granted
    case denied
    case iMessageNotAvailable
    
    var description: String {
        switch self {
        case .granted:
            return "Full Disk Access granted"
        case .denied:
            return "Full Disk Access required"
        case .iMessageNotAvailable:
            return "iMessage database not found"
        }
    }
    
    var isValid: Bool {
        return self == .granted
    }
} 