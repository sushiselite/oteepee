import SwiftUI
import AppKit

struct MenuBarView: View {
    @EnvironmentObject var messageMonitor: MessageMonitor
    @EnvironmentObject var notificationManager: NotificationManager
    @EnvironmentObject var clipboardManager: ClipboardManager
    @Environment(\.openWindow) private var openWindow
    
    @State private var showingSettings = false
    @State private var permissionStatus = FilePermissions.checkPermissionStatus()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack {
                Image(systemName: "lock.shield.fill")
                    .foregroundColor(.blue)
                Text("OTeePee")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Circle()
                    .fill(messageMonitor.isMonitoring ? .green : .gray)
                    .frame(width: 8, height: 8)
            }
            
            Divider()
            
            // Status Section
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: permissionStatus.isValid ? "checkmark.shield" : "exclamationmark.shield")
                        .foregroundColor(permissionStatus.isValid ? .green : .orange)
                    Text(permissionStatus.description)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                HStack {
                    Image(systemName: "message.fill")
                        .foregroundColor(.blue)
                    Text(messageMonitor.statusMessage)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            
            Divider()
            
            // Stats Section
            HStack {
                VStack(alignment: .leading) {
                    Text("OTPs Found")
                        .font(.caption2)
                        .foregroundColor(.textSecondary)
                    Text("\(messageMonitor.otpCount)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.otpBlue)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Last OTP")
                        .font(.caption2)
                        .foregroundColor(.textSecondary)
                    if let lastOTP = messageMonitor.lastOTP {
                        Text(lastOTP)
                            .font(.system(.title2, design: .monospaced))
                            .fontWeight(.bold)
                            .foregroundColor(.otpGreen)
                    } else {
                        Text("None")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                }
            }
            
            // Last OTP Quick Actions
            if let lastOTP = messageMonitor.lastOTP {
                HStack {
                    Button("Copy Again") {
                        clipboardManager.copyManually(lastOTP)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    
                    Spacer()
                }
            }
            
            Divider()
            
            // Control Buttons
            VStack(spacing: 6) {
                HStack {
                    Button("Settings") {
                        showSettingsWindow()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Setup Guide") {
                        showOnboardingWindow()
                    }
                    .buttonStyle(.bordered)
                }
                
                HStack {
                    Button("Check Permissions") {
                        checkPermissions()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Quit OTeePee") {
                        NSApplication.shared.terminate(nil)
                    }
                    .buttonStyle(.bordered)
                }
                
                // Debug option to reset onboarding (only show if option key is held)
                if NSEvent.modifierFlags.contains(.option) {
                    Button("Reset Onboarding") {
                        UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
                        print("Onboarding flag reset - app will show onboarding on next launch")
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                }
            }
        }
        .padding(12)
        .frame(width: 280)
        .background(Color.backgroundPrimary)
        .onAppear {
            refreshPermissionStatus()
        }
    }
    

    
    private func showSettingsWindow() {
        print("Settings button clicked - opening settings window")
        
        WindowManager.shared.showSettingsWindow(
            messageMonitor: messageMonitor,
            notificationManager: notificationManager,
            clipboardManager: clipboardManager
        )
    }
    
    private func showOnboardingWindow() {
        print("Setup Guide button clicked - opening onboarding window")
        
        WindowManager.shared.showOnboardingWindow(
            messageMonitor: messageMonitor,
            notificationManager: notificationManager,
            clipboardManager: clipboardManager
        )
    }
    
    private func checkPermissions() {
        refreshPermissionStatus()
        
        if !permissionStatus.isValid {
            FilePermissions.openSystemPreferences()
        }
    }
    
    private func refreshPermissionStatus() {
        permissionStatus = FilePermissions.checkPermissionStatus()
    }
}

#Preview {
    MenuBarView()
        .environmentObject(MessageMonitor())
        .environmentObject(NotificationManager())
        .environmentObject(ClipboardManager())
} 