import Foundation
import SQLite3
import Combine

class MessageMonitor: ObservableObject {
    @Published var isMonitoring = false
    @Published var lastOTP: String?
    @Published var otpCount = 0
    @Published var statusMessage = "Ready"
    
    private var timer: Timer?
    private var lastMessageRowID: Int64 = 0
    private let otpParser = OTPParser()
    private let clipboardManager = ClipboardManager()
    private let notificationManager = NotificationManager()
    
    // iMessage database path
    private let iMessageDBPath = "\(NSHomeDirectory())/Library/Messages/chat.db"
    
    init() {
        loadLastProcessedMessage()
        loadOTPCount()
        
        // Auto-start monitoring if we have permissions
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.autoStartMonitoringIfPossible()
        }
    }
    
    private func autoStartMonitoringIfPossible() {
        guard !isMonitoring else { return }
        
        // Check if we have full disk access and database exists
        if FileManager.default.fileExists(atPath: iMessageDBPath) && FilePermissions.hasFullDiskAccess() {
            print("Auto-starting monitoring with full disk access")
            startMonitoring()
        } else {
            statusMessage = "Ready"
            print("Cannot auto-start: permissions not available")
        }
    }
    
    deinit {
        stopMonitoring()
    }
    
    func startMonitoring() {
        guard !isMonitoring else { return }
        
        // Check if iMessage database exists and is accessible
        guard FileManager.default.fileExists(atPath: iMessageDBPath) else {
            statusMessage = "iMessage database not found"
            return
        }
        
        guard FilePermissions.hasFullDiskAccess() else {
            statusMessage = "Full Disk Access required"
            return
        }
        
        isMonitoring = true
        statusMessage = "Ready"
        
        // Start polling for new messages every 2 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            self.checkForNewMessages()
        }
        
        // Also check immediately
        checkForNewMessages()
    }
    
    func stopMonitoring() {
        isMonitoring = false
        statusMessage = "Ready"
        timer?.invalidate()
        timer = nil
    }
    
    private func checkForNewMessages() {
        var db: OpaquePointer?
        
        guard sqlite3_open_v2(iMessageDBPath, &db, SQLITE_OPEN_READONLY, nil) == SQLITE_OK else {
            print("Unable to open iMessage database")
            return
        }
        
        defer {
            sqlite3_close(db)
        }
        
        // Query for new messages since last check
        let query = """
            SELECT 
                message.ROWID,
                message.text,
                message.date,
                handle.id as sender
            FROM message 
            LEFT JOIN handle ON message.handle_id = handle.ROWID 
            WHERE message.ROWID > ? 
                AND message.text IS NOT NULL 
                AND message.text != ''
                AND message.is_from_me = 0
            ORDER BY message.date ASC
        """
        
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            print("Failed to prepare SQL statement")
            return
        }
        
        defer {
            sqlite3_finalize(statement)
        }
        
        sqlite3_bind_int64(statement, 1, lastMessageRowID)
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let rowID = sqlite3_column_int64(statement, 0)
            
            if let textPointer = sqlite3_column_text(statement, 1) {
                let messageText = String(cString: textPointer)
                let sender = sqlite3_column_text(statement, 3).map { String(cString: $0) } ?? "Unknown"
                
                // Process message for OTP
                processMessage(messageText, from: sender, rowID: rowID)
            }
            
            lastMessageRowID = max(lastMessageRowID, rowID)
        }
        
        saveLastProcessedMessage()
    }
    
    private func processMessage(_ messageText: String, from sender: String, rowID: Int64) {
        if let otp = otpParser.extractOTP(from: messageText) {
            DispatchQueue.main.async {
                self.lastOTP = otp
                self.otpCount += 1
                self.statusMessage = "Found OTP: \(otp)"
                
                // Save updated count
                self.saveOTPCount()
                
                // Copy to clipboard
                self.clipboardManager.copyToClipboard(otp)
                
                // Show notification
                self.notificationManager.showOTPNotification(otp: otp, from: sender)
                
                print("OTP detected: \(otp) from \(sender)")
            }
        }
    }
    
    private func loadLastProcessedMessage() {
        lastMessageRowID = UserDefaults.standard.object(forKey: "lastMessageRowID") as? Int64 ?? 0
    }
    
    private func saveLastProcessedMessage() {
        UserDefaults.standard.set(lastMessageRowID, forKey: "lastMessageRowID")
    }
    
    private func loadOTPCount() {
        otpCount = UserDefaults.standard.integer(forKey: "otpCount")
    }
    
    private func saveOTPCount() {
        UserDefaults.standard.set(otpCount, forKey: "otpCount")
    }
    
    func resetProcessedMessages() {
        lastMessageRowID = 0
        saveLastProcessedMessage()
        statusMessage = "Ready"
    }
    
    func resetAllStatistics() {
        // Reset message processing
        lastMessageRowID = 0
        saveLastProcessedMessage()
        
        // Reset OTP statistics
        DispatchQueue.main.async {
            self.otpCount = 0
            self.lastOTP = nil
            self.statusMessage = "Ready"
        }
        
        // Reset UserDefaults statistics
        UserDefaults.standard.set(0, forKey: "otpCount")
        
        print("All statistics reset")
    }
} 