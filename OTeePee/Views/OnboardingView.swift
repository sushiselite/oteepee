import SwiftUI
import UserNotifications

struct OnboardingView: View {
    @EnvironmentObject var messageMonitor: MessageMonitor
    @EnvironmentObject var notificationManager: NotificationManager
    @EnvironmentObject var clipboardManager: ClipboardManager
    
    @State private var currentStep = 0
    @State private var permissionStatus = FilePermissions.checkPermissionStatus()
    @State private var notificationPermissionGranted = false
    
    let onOnboardingComplete: () -> Void
    
    private let totalSteps = 4
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress indicator
            ProgressIndicator(currentStep: currentStep, totalSteps: totalSteps)
                .padding(.top, 20)
            
            // Main content - Fixed height container to prevent scrolling
            VStack {
                switch currentStep {
                case 0:
                    WelcomeStep()
                case 1:
                    ExplainStep()
                case 2:
                    PermissionsStep(
                        permissionStatus: $permissionStatus,
                        notificationPermissionGranted: $notificationPermissionGranted
                    )
                case 3:
                    CompletionStep()
                default:
                    WelcomeStep()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .animation(.easeInOut(duration: 0.3), value: currentStep)
            
            // Navigation buttons
            NavigationButtons(
                currentStep: $currentStep,
                totalSteps: totalSteps,
                permissionStatus: permissionStatus,
                notificationPermissionGranted: notificationPermissionGranted,
                onComplete: {
                    completeOnboarding()
                }
            )
            .padding(.bottom, 20)
        }
        .frame(width: 700, height: 500)
        .background(Color.backgroundPrimary)
        .onAppear {
            refreshPermissionStatus()
        }
    }
    
    private func refreshPermissionStatus() {
        permissionStatus = FilePermissions.checkPermissionStatus()
        
        // Check notification permissions
        notificationManager.checkNotificationPermissions { granted in
            DispatchQueue.main.async {
                notificationPermissionGranted = granted
            }
        }
    }
    
    private func completeOnboarding() {
        // Mark onboarding as complete
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        
        // Set default preferences
        UserDefaults.standard.set(true, forKey: "startAtLogin")
        UserDefaults.standard.set(true, forKey: "startAtLoginConfigured")
        
        onOnboardingComplete()
    }
}

// MARK: - Progress Indicator
struct ProgressIndicator: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalSteps, id: \.self) { step in
                Circle()
                    .fill(step <= currentStep ? Color.blue : Color.gray.opacity(0.3))
                    .frame(width: 12, height: 12)
                    .scaleEffect(step == currentStep ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: currentStep)
                
                if step < totalSteps - 1 {
                    Rectangle()
                        .fill(step < currentStep ? Color.blue : Color.gray.opacity(0.3))
                        .frame(width: 40, height: 2)
                }
            }
        }
        .padding(.horizontal, 40)
    }
}

// MARK: - Welcome Step
struct WelcomeStep: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // App icon and title
            VStack(spacing: 16) {
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                    .shadow(color: .blue.opacity(0.3), radius: 10)
                
                Text("Welcome to OTeePee")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                
                Text("Automatic OTP Detection & Clipboard Copy")
                    .font(.title3)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            // Quick intro
            VStack(spacing: 12) {
                Text("Never type OTP codes again!")
                    .font(.headline)
                    .foregroundColor(.blue)
                
                Text("OTeePee automatically detects OTP codes from your iMessage and copies them to your clipboard instantly.")
                    .font(.body)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 60)
            }
            
            Spacer()
        }
        .padding(30)
    }
}

// MARK: - Explain Step
struct ExplainStep: View {
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 12) {
                Image(systemName: "gearshape.2.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.blue)
                
                Text("How It Works")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
            }
            
            VStack(spacing: 16) {
                FeatureExplanation(
                    icon: "message.fill",
                    title: "Monitors iMessage",
                    description: "Continuously watches your iMessage for incoming text messages containing OTP codes"
                )
                
                FeatureExplanation(
                    icon: "eye.fill",
                    title: "Smart Detection",
                    description: "Uses advanced patterns to recognize various OTP formats from different services"
                )
                
                FeatureExplanation(
                    icon: "doc.on.clipboard.fill",
                    title: "Auto-Copy",
                    description: "Instantly copies detected OTP codes to your clipboard for easy pasting"
                )
                
                FeatureExplanation(
                    icon: "bell.fill",
                    title: "Notifications",
                    description: "Shows helpful notifications when OTP codes are detected and copied"
                )
            }
            
            // Privacy note
            VStack(spacing: 6) {
                HStack {
                    Image(systemName: "shield.checkered")
                        .foregroundColor(.green)
                    Text("100% Privacy Focused")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }
                
                Text("Everything happens locally on your device. No data is sent anywhere.")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(12)
            .background(Color.green.opacity(0.1))
            .cornerRadius(8)
            .padding(.horizontal, 40)
        }
        .padding(30)
    }
}

// MARK: - Permissions Step
struct PermissionsStep: View {
    @EnvironmentObject var notificationManager: NotificationManager
    @Binding var permissionStatus: PermissionStatus
    @Binding var notificationPermissionGranted: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 12) {
                Image(systemName: "shield.lefthalf.filled")
                    .font(.system(size: 50))
                    .foregroundColor(.orange)
                
                Text("Grant Permissions")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                
                Text("OTeePee needs a couple of permissions to work properly")
                    .font(.body)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            VStack(spacing: 16) {
                // Full Disk Access Permission
                OnboardingPermissionCard(
                    icon: "folder.fill",
                    title: "Full Disk Access",
                    description: "Required to read iMessage database for OTP detection",
                    status: permissionStatus.isValid ? .granted : .required,
                    buttonTitle: permissionStatus.isValid ? "Granted" : "Grant Access",
                    action: {
                        FilePermissions.openSystemPreferences()
                        
                        // Check status after a delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            permissionStatus = FilePermissions.checkPermissionStatus()
                        }
                    }
                )
                
                // Notification Permission
                OnboardingPermissionCard(
                    icon: "bell.fill",
                    title: "Notifications",
                    description: "Show alerts when OTP codes are detected and copied",
                    status: notificationPermissionGranted ? .granted : .optional,
                    buttonTitle: notificationPermissionGranted ? "Granted" : "Grant Permission",
                    action: {
                        notificationManager.requestNotificationPermissions { granted in
                            DispatchQueue.main.async {
                                notificationPermissionGranted = granted
                            }
                        }
                    }
                )
            }
            
            // Important note
            if !permissionStatus.isValid {
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        Text("Important")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.orange)
                    }
                    
                    Text("Full Disk Access is required for OTeePee to function. After granting this permission, you may need to restart the app.")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .padding(12)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
                .padding(.horizontal, 40)
            }
        }
        .padding(30)
    }
}

// MARK: - Completion Step
struct CompletionStep: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            VStack(spacing: 16) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                    .shadow(color: .green.opacity(0.3), radius: 10)
                
                Text("All Set!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                
                Text("OTeePee is now ready to detect and copy OTP codes automatically")
                    .font(.title3)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            VStack(spacing: 12) {
                Text("What happens next?")
                    .font(.headline)
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 8) {
                    CompletionPoint(
                        icon: "menubar.rectangle",
                        text: "OTeePee will appear in your menu bar"
                    )
                    
                    CompletionPoint(
                        icon: "message.fill",
                        text: "It will automatically monitor for OTP codes"
                    )
                    
                    CompletionPoint(
                        icon: "doc.on.clipboard",
                        text: "Codes will be copied to your clipboard instantly"
                    )
                    
                    CompletionPoint(
                        icon: "bell",
                        text: "You'll get notifications when codes are detected"
                    )
                }
            }
            
            Spacer()
        }
        .padding(30)
    }
}

// MARK: - Navigation Buttons
struct NavigationButtons: View {
    @Binding var currentStep: Int
    let totalSteps: Int
    let permissionStatus: PermissionStatus
    let notificationPermissionGranted: Bool
    let onComplete: () -> Void
    
    var canProceed: Bool {
        if currentStep == 2 { // Permissions step
            return permissionStatus.isValid
        }
        return true
    }
    
    var body: some View {
        HStack {
            // Back button
            if currentStep > 0 {
                Button("Back") {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentStep -= 1
                    }
                }
                .buttonStyle(.bordered)
            } else {
                Spacer()
                    .frame(width: 60)
            }
            
            Spacer()
            
            // Next/Complete button
            if currentStep < totalSteps - 1 {
                Button(currentStep == 2 ? "Continue" : "Next") {
                    if canProceed {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentStep += 1
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(!canProceed)
            } else {
                Button("Get Started") {
                    onComplete()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
        }
        .padding(.horizontal, 40)
    }
}

// MARK: - Helper Views
struct FeatureExplanation: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct OnboardingPermissionCard: View {
    let icon: String
    let title: String
    let description: String
    let status: PermissionRowStatus
    let buttonTitle: String
    let action: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(status == .granted ? .green : .blue)
                .frame(width: 24)
            
            // Content
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            // Status and button
            VStack(spacing: 6) {
                statusIndicator
                
                if status != .granted {
                    Button(buttonTitle) {
                        action()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
                }
            }
        }
        .padding(16)
        .background(Color.backgroundSecondary)
        .cornerRadius(8)
        .padding(.horizontal, 40)
    }
    
    @ViewBuilder
    private var statusIndicator: some View {
        switch status {
        case .granted:
            Label("Granted", systemImage: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.caption2)
        case .required:
            Label("Required", systemImage: "exclamationmark.circle.fill")
                .foregroundColor(.orange)
                .font(.caption2)
        case .optional:
            Label("Optional", systemImage: "circle")
                .foregroundColor(.gray)
                .font(.caption2)
        }
    }
}

struct CompletionPoint: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.green)
                .frame(width: 16)
            
            Text(text)
                .font(.caption)
                .foregroundColor(.textSecondary)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(onOnboardingComplete: {})
        .environmentObject(MessageMonitor())
        .environmentObject(NotificationManager())
        .environmentObject(ClipboardManager())
} 