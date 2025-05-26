import Foundation
import AppKit

class ClipboardManager: ObservableObject {
    @Published var lastCopiedOTP: String?
    @Published var copyCount = 0
    
    private let pasteboard = NSPasteboard.general
    
    func copyToClipboard(_ text: String) {
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
        
        DispatchQueue.main.async {
            self.lastCopiedOTP = text
            self.copyCount += 1
        }
        
        print("Copied to clipboard: \(text)")
    }
    
    func getClipboardContents() -> String? {
        return pasteboard.string(forType: .string)
    }
    
    func clearClipboard() {
        pasteboard.clearContents()
        
        DispatchQueue.main.async {
            self.lastCopiedOTP = nil
        }
    }
    
    func copyManually(_ text: String) {
        copyToClipboard(text)
    }
    
    func resetStatistics() {
        DispatchQueue.main.async {
            self.copyCount = 0
            self.lastCopiedOTP = nil
        }
        print("Clipboard statistics reset")
    }
} 