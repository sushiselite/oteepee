import XCTest
@testable import OTeePee

final class OTeePeeTests: XCTestCase {
    
    var otpParser: OTPParser!
    
    override func setUpWithError() throws {
        otpParser = OTPParser()
    }
    
    override func tearDownWithError() throws {
        otpParser = nil
    }
    
    // MARK: - OTP Parser Tests
    
    func testBasicOTPExtraction() throws {
        let testMessages = [
            "Your verification code is 123456",
            "Use code 789012 to sign in",
            "Your Apple ID code is 345678",
            "Google verification code: 567890",
            "Security code 234567 for your account",
            "PIN: 456789",
            "OTP 678901"
        ]
        
        let expectedCodes = ["123456", "789012", "345678", "567890", "234567", "456789", "678901"]
        
        for (index, message) in testMessages.enumerated() {
            let extractedOTP = otpParser.extractOTP(from: message)
            XCTAssertEqual(extractedOTP, expectedCodes[index], "Failed to extract OTP from: \(message)")
        }
    }
    
    func testServiceSpecificPatterns() throws {
        let testMessages = [
            "Apple ID verification code: 123456",
            "G-789012 is your Google verification code",
            "Microsoft account security code: 345678"
        ]
        
        let expectedCodes = ["123456", "789012", "345678"]
        
        for (index, message) in testMessages.enumerated() {
            let extractedOTP = otpParser.extractOTP(from: message)
            XCTAssertEqual(extractedOTP, expectedCodes[index], "Failed to extract service-specific OTP from: \(message)")
        }
    }
    
    func testInvalidMessages() throws {
        let invalidMessages = [
            "Hello how are you today?",
            "Meeting at 3 PM tomorrow",
            "Your order #12345 has been shipped",
            "Call me at 555-1234",
            "Temperature is 72 degrees"
        ]
        
        for message in invalidMessages {
            let extractedOTP = otpParser.extractOTP(from: message)
            XCTAssertNil(extractedOTP, "Should not extract OTP from: \(message)")
        }
    }
    
    func testFalsePositives() throws {
        let falsePositiveMessages = [
            "Meeting room 1234",
            "Order number 123456",
            "Call 555-1234 for support"
        ]
        
        for message in falsePositiveMessages {
            let extractedOTP = otpParser.extractOTP(from: message)
            XCTAssertNil(extractedOTP, "Should not extract OTP from false positive: \(message)")
        }
    }
    
    func testAlphanumericOTPs() throws {
        let testMessages = [
            "Your verification code is ABC123",
            "Security code: XYZ789",
            "Use code A1B2C3 to continue"
        ]
        
        let expectedCodes = ["ABC123", "XYZ789", "A1B2C3"]
        
        for (index, message) in testMessages.enumerated() {
            let extractedOTP = otpParser.extractOTP(from: message)
            XCTAssertEqual(extractedOTP, expectedCodes[index], "Failed to extract alphanumeric OTP from: \(message)")
        }
    }
    
    // MARK: - String Extension Tests
    
    func testStringValidOTP() throws {
        XCTAssertTrue("123456".isValidOTP)
        XCTAssertTrue("ABC123".isValidOTP)
        XCTAssertTrue("12AB34".isValidOTP)
        
        XCTAssertFalse("12".isValidOTP) // Too short
        XCTAssertFalse("123456789".isValidOTP) // Too long
        XCTAssertFalse("ABCDEF".isValidOTP) // No digits
        XCTAssertFalse("12@#45".isValidOTP) // Invalid characters
    }
    
    func testStringContainsOTPKeywords() throws {
        XCTAssertTrue("Your verification code is 123456".containsOTPKeywords())
        XCTAssertTrue("Security PIN for your account".containsOTPKeywords())
        XCTAssertTrue("Login authentication required".containsOTPKeywords())
        
        XCTAssertFalse("Hello how are you?".containsOTPKeywords())
        XCTAssertFalse("Meeting at 3 PM".containsOTPKeywords())
    }
    
    // MARK: - Performance Tests
    
    func testOTPExtractionPerformance() throws {
        let testMessage = "Your Apple ID verification code is 123456. Don't share this code with anyone."
        
        measure {
            for _ in 0..<1000 {
                _ = otpParser.extractOTP(from: testMessage)
            }
        }
    }
} 