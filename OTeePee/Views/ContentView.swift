import SwiftUI
import ServiceManagement

struct ContentView: View {
    @EnvironmentObject var messageMonitor: MessageMonitor
    @EnvironmentObject var notificationManager: NotificationManager
    @EnvironmentObject var clipboardManager: ClipboardManager
    
    @State private var selectedTab = 0
    @State private var permissionStatus = FilePermissions.checkPermissionStatus()
    @State private var showingPermissionAlert = false
    @State private var showingOnboarding = false
    
    var body: some View {
        Group {
            if showingOnboarding {
                OnboardingView {
                    showingOnboarding = false
                }
            } else {
                TabView(selection: $selectedTab) {
                    // Status Tab
                    StatusView()
                        .tabItem {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                            Text("Status")
                        }
                        .tag(0)
                    
                    // Permissions Tab
                    PermissionsView()
                        .tabItem {
                            Image(systemName: "shield.checkered")
                            Text("Permissions")
                        }
                        .tag(1)
                    
                    // Settings Tab
                    SettingsView()
                        .tabItem {
                            Image(systemName: "gear")
                            Text("Settings")
                        }
                        .tag(2)
                    
                    // About Tab
                    AboutView()
                        .tabItem {
                            Image(systemName: "info.circle")
                            Text("About")
                        }
                        .tag(3)
                }
                .frame(minWidth: 600, minHeight: 400)
            }
        }
        .onAppear {
            checkForFirstLaunch()
            refreshPermissionStatus()
        }
    }
    
    private func checkForFirstLaunch() {
        // Check if this is the first time launching the app
        let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        showingOnboarding = !hasCompletedOnboarding
    }
    
    private func refreshPermissionStatus() {
        permissionStatus = FilePermissions.checkPermissionStatus()
    }
}

// MARK: - Status View
struct StatusView: View {
    @EnvironmentObject var messageMonitor: MessageMonitor
    @EnvironmentObject var notificationManager: NotificationManager
    @EnvironmentObject var clipboardManager: ClipboardManager
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.title)
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading) {
                        Text("OTeePee Status")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Monitor iMessage for OTP codes")
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                    
                    // Status Indicator
                    HStack {
                        Circle()
                            .fill(messageMonitor.isMonitoring ? .green : .red)
                            .frame(width: 12, height: 12)
                        
                        Text(messageMonitor.isMonitoring ? "Active" : "Inactive")
                            .font(.headline)
                            .foregroundColor(messageMonitor.isMonitoring ? .green : .red)
                    }
                }
                
                Divider()
                
                // Statistics Card
                HStack {
                    Spacer()
                    StatCard(
                        title: "OTPs Detected",
                        value: "\(messageMonitor.otpCount)",
                        icon: "shield.checkered",
                        color: .blue
                    )
                    Spacer()
                }
                
                // Current Status
                VStack(alignment: .leading, spacing: 12) {
                    Text("Current Status")
                        .font(.headline)
                    
                    StatusRow(
                        icon: "message.fill",
                        title: "Message Monitor",
                        status: messageMonitor.statusMessage,
                        isActive: messageMonitor.isMonitoring
                    )
                    
                    StatusRow(
                        icon: "bell.fill",
                        title: "Notifications",
                        status: notificationManager.notificationsEnabled ? "Enabled" : "Disabled",
                        isActive: notificationManager.notificationsEnabled
                    )
                    
                    if let lastOTP = messageMonitor.lastOTP {
                        StatusRow(
                            icon: "key.fill",
                            title: "Last OTP",
                            status: lastOTP,
                            isActive: true
                        )
                    }
                }
                
                // Quick Actions
                VStack(alignment: .leading, spacing: 12) {
                    Text("Quick Actions")
                        .font(.headline)
                    
                    HStack {
                        Button("Reset Statistics") {
                            resetStatistics()
                        }
                        .buttonStyle(.bordered)
                        
                        if let lastOTP = messageMonitor.lastOTP {
                            Button("Copy Last OTP") {
                                clipboardManager.copyManually(lastOTP)
                            }
                            .buttonStyle(.bordered)
                        }
                        
                        Spacer()
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
    private func resetStatistics() {
        // Reset all statistics across all managers
        messageMonitor.resetAllStatistics()
        clipboardManager.resetStatistics()
        notificationManager.resetStatistics()
        
        print("All statistics have been reset")
    }
}

// MARK: - Settings View
struct SettingsView: View {
    @EnvironmentObject var messageMonitor: MessageMonitor
    @EnvironmentObject var notificationManager: NotificationManager
    @EnvironmentObject var clipboardManager: ClipboardManager
    
    @State private var startAtLogin = true
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Settings")
                    .font(.title)
                    .fontWeight(.bold)
                
                Divider()
                
                // General Settings
                VStack(alignment: .leading, spacing: 12) {
                    Text("General")
                        .font(.headline)
                    
                    Toggle("Start at login", isOn: $startAtLogin)
                        .onAppear {
                            // Set default to true for new users
                            if !(UserDefaults.standard.object(forKey: "startAtLoginConfigured") as? Bool ?? false) {
                                UserDefaults.standard.set(true, forKey: "startAtLogin")
                                UserDefaults.standard.set(true, forKey: "startAtLoginConfigured")
                            }
                            startAtLogin = isLoginItemEnabled()
                        }
                        .onChange(of: startAtLogin) { _, value in
                            setLoginItem(enabled: value)
                        }
                    HStack {
                        Text("Notifications:")
                        Spacer()
                        Text(notificationManager.notificationsEnabled ? "Enabled" : "Disabled")
                            .foregroundColor(notificationManager.notificationsEnabled ? .green : .red)
                    }
                    
                    if !notificationManager.notificationsEnabled {
                        Button("Grant Notification Permission") {
                            notificationManager.requestNotificationPermissions()
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.small)
                    }
                }
                

                
                // Database Settings
                VStack(alignment: .leading, spacing: 12) {
                    Text("Database")
                        .font(.headline)
                    
                    Button("Reset all statistics") {
                        messageMonitor.resetAllStatistics()
                        clipboardManager.resetStatistics()
                        notificationManager.resetStatistics()
                    }
                    .buttonStyle(.bordered)
                    
                    Text("Clear the record of processed messages to re-scan all messages")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                // Help & Support
                VStack(alignment: .leading, spacing: 12) {
                    Text("Help & Support")
                        .font(.headline)
                    
                    Button("Show Setup Guide") {
                        showOnboardingAgain()
                    }
                    .buttonStyle(.bordered)
                    
                    Text("Run through the initial setup process again")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
    private func showOnboardingAgain() {
        WindowManager.shared.showOnboardingWindow(
            messageMonitor: messageMonitor,
            notificationManager: notificationManager,
            clipboardManager: clipboardManager
        )
    }
    
    // MARK: - Login Item Management
    private func isLoginItemEnabled() -> Bool {
        // For now, just return the stored preference
        return UserDefaults.standard.bool(forKey: "startAtLogin")
    }
    
    private func setLoginItem(enabled: Bool) {
        // Store preference (actual login item would require a helper app)
        UserDefaults.standard.set(enabled, forKey: "startAtLogin")
        print("Set start at login preference: \(enabled)")
        
        // TODO: Implement actual login item functionality with helper app
        // For now, just inform the user
        if enabled {
            print("Login item functionality requires additional setup")
        }
    }
}

// MARK: - About View
struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // App Icon and Info
                VStack(spacing: 12) {
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 64))
                        .foregroundColor(.blue)
                    
                    Text("OTeePee")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Automatic OTP Detection & Clipboard Copy")
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                    
                    Text("Version 1.0")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                Divider()
                
                // Description
                VStack(alignment: .leading, spacing: 12) {
                    Text("About OTeePee")
                        .font(.headline)
                    
                    Text("OTeePee automatically monitors your iMessage for incoming OTP (One-Time Password) codes and copies them directly to your clipboard with helpful notifications. Perfect for seamless 2FA authentication in any browser or application.")
                        .font(.body)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                // Features
                VStack(alignment: .leading, spacing: 8) {
                    Text("Features")
                        .font(.headline)
                    
                    FeatureRow(icon: "eye", text: "Automatic OTP Detection")
                    FeatureRow(icon: "doc.on.clipboard", text: "Instant Clipboard Copy")
                    FeatureRow(icon: "bell", text: "Native macOS Notifications")
                    FeatureRow(icon: "shield", text: "Privacy First - Everything Local")
                    FeatureRow(icon: "menubar.rectangle", text: "Menu Bar Integration")
                }
                
                // Links
                VStack(spacing: 8) {
                    Button("View on GitHub") {
                        if let url = URL(string: "https://github.com/yourusername/oteepee") {
                            NSWorkspace.shared.open(url)
                        }
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Report Issue") {
                        if let url = URL(string: "https://github.com/yourusername/oteepee/issues") {
                            NSWorkspace.shared.open(url)
                        }
                    }
                    .buttonStyle(.bordered)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

// MARK: - Helper Views
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.backgroundSecondary)
        .cornerRadius(8)
    }
}

struct StatusRow: View {
    let icon: String
    let title: String
    let status: String
    let isActive: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(isActive ? .green : .gray)
                .frame(width: 20)
            
            Text(title)
                .font(.body)
            
            Spacer()
            
            Text(status)
                .font(.body)
                .foregroundColor(isActive ? .textPrimary : .textSecondary)
        }
        .padding(.vertical, 4)
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(text)
                .font(.body)
            
            Spacer()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(MessageMonitor())
        .environmentObject(NotificationManager())
        .environmentObject(ClipboardManager())
} 