import Foundation

class OTPParser {
    
    // Common OTP patterns with different formats
    private let otpPatterns: [NSRegularExpression] = {
        let patterns = [
            // Basic 4-8 digit codes
            "\\b\\d{4}\\b",               // 4 digits
            "\\b\\d{5}\\b",               // 5 digits  
            "\\b\\d{6}\\b",               // 6 digits
            "\\b\\d{7}\\b",               // 7 digits
            "\\b\\d{8}\\b",               // 8 digits
            
            // Alphanumeric codes (3-8 characters)
            "\\b[A-Z0-9]{3,8}\\b",        // Uppercase alphanumeric
            "\\b[a-z0-9]{3,8}\\b",        // Lowercase alphanumeric
            "\\b[A-Za-z0-9]{3,8}\\b",     // Mixed case alphanumeric
            
            // Codes with specific keywords
            "(?:code|verification|verify|pin|otp)[\\s:]*([A-Za-z0-9]{3,8})",
            "([A-Za-z0-9]{3,8})[\\s]*(?:is your|code)",
            
            // Codes in quotes or parentheses
            "\"([A-Za-z0-9]{3,8})\"",
            "\\(([A-Za-z0-9]{3,8})\\)",
            
            // Codes after common prefixes
            "(?:use|enter|type)[\\s:]*([A-Za-z0-9]{3,8})",
            "(?:security|access)[\\s]*code[\\s:]*([A-Za-z0-9]{3,8})"
        ]
        
        return patterns.compactMap { pattern in
            try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
        }
    }()
    
    // Keywords that commonly appear in OTP messages
    private let otpKeywords = [
        "verification", "verify", "code", "pin", "otp", "security", "access",
        "authentication", "confirm", "temporary", "login", "signin", "account",
        "password", "passcode", "unlock", "activate", "validate", "valid"
    ]
    
    // Service-specific patterns for better accuracy
    private let servicePatterns: [String: NSRegularExpression] = {
        var patterns: [String: NSRegularExpression] = [:]
        
        // Apple
        if let applePattern = try? NSRegularExpression(pattern: "Apple.{0,20}(\\d{6})", options: .caseInsensitive) {
            patterns["Apple"] = applePattern
        }
        
        // Google
        if let googlePattern = try? NSRegularExpression(pattern: "G-\\d{6}|Google.{0,20}(\\d{6})", options: .caseInsensitive) {
            patterns["Google"] = googlePattern
        }
        
        // Microsoft
        if let msPattern = try? NSRegularExpression(pattern: "Microsoft.{0,20}(\\d{6})", options: .caseInsensitive) {
            patterns["Microsoft"] = msPattern
        }
        
        // Banking/Financial
        if let bankPattern = try? NSRegularExpression(pattern: "(?:bank|chase|wells|citi|bofa).{0,20}(\\d{4,8})", options: .caseInsensitive) {
            patterns["Banking"] = bankPattern
        }
        
        return patterns
    }()
    
    func extractOTP(from message: String) -> String? {
        let cleanMessage = message.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // First check if message likely contains an OTP based on keywords
        guard containsOTPKeywords(cleanMessage) else {
            return nil
        }
        
        // Try service-specific patterns first (more accurate)
        for (_, pattern) in servicePatterns {
            if let match = findFirstMatch(in: cleanMessage, with: pattern) {
                return match
            }
        }
        
        // Try general patterns
        for pattern in otpPatterns {
            if let match = findFirstMatch(in: cleanMessage, with: pattern) {
                // Validate the extracted code
                if isValidOTP(match) {
                    return match
                }
            }
        }
        
        return nil
    }
    
    private func containsOTPKeywords(_ message: String) -> Bool {
        let lowercaseMessage = message.lowercased()
        return otpKeywords.contains { keyword in
            lowercaseMessage.contains(keyword)
        }
    }
    
    private func findFirstMatch(in text: String, with regex: NSRegularExpression) -> String? {
        let range = NSRange(text.startIndex..., in: text)
        
        if let match = regex.firstMatch(in: text, options: [], range: range) {
            // Try to extract from capture group first, then full match
            if match.numberOfRanges > 1 {
                let captureRange = match.range(at: 1)
                if captureRange.location != NSNotFound,
                   let range = Range(captureRange, in: text) {
                    return String(text[range])
                }
            }
            
            // Fall back to full match
            if let range = Range(match.range, in: text) {
                return String(text[range])
            }
        }
        
        return nil
    }
    
    private func isValidOTP(_ code: String) -> Bool {
        // Basic validation rules
        let trimmedCode = code.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Must be 3-8 characters
        guard trimmedCode.count >= 3 && trimmedCode.count <= 8 else {
            return false
        }
        
        // Should contain at least one digit
        guard trimmedCode.rangeOfCharacter(from: .decimalDigits) != nil else {
            return false
        }
        
        // Exclude common false positives
        let falsePosivites = ["1111", "2222", "3333", "4444", "5555", "6666", "7777", "8888", "9999", "0000", "1234", "4321"]
        guard !falsePosivites.contains(trimmedCode) else {
            return false
        }
        
        // Check for too many repeated characters
        let uniqueChars = Set(trimmedCode)
        if uniqueChars.count == 1 {
            return false // All same character
        }
        
        return true
    }
}

// MARK: - Extension for testing
extension OTPParser {
    func testExtraction(from messages: [String]) -> [String?] {
        return messages.map { extractOTP(from: $0) }
    }
} 