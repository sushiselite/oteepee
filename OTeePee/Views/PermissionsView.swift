import SwiftUI
import UserNotifications

struct PermissionsView: View {
    @EnvironmentObject var notificationManager: NotificationManager
    @State private var permissionStatus = FilePermissions.checkPermissionStatus()
    @State private var showingDetailedInstructions = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    Image(systemName: "shield.checkered")
                        .font(.title)
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading) {
                        Text("Permissions")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Required for OTeePee to function")
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                }
                
                Divider()
                
                // Permission Status Overview
                PermissionStatusCard(status: permissionStatus)
                
                // Required Permissions List
                VStack(alignment: .leading, spacing: 16) {
                    Text("Required Permissions")
                        .font(.headline)
                    
                    PermissionRow(
                        icon: "folder.fill",
                        title: "Full Disk Access",
                        description: "Required to read iMessage database",
                        status: permissionStatus.isValid ? .granted : .required,
                        action: {
                            FilePermissions.openSystemPreferences()
                        }
                    )
                    
                    PermissionRow(
                        icon: "bell.fill",
                        title: "Notifications",
                        description: "Show alerts when OTPs are detected",
                        status: notificationManager.notificationsEnabled ? .granted : .optional,
                        action: {
                            notificationManager.requestNotificationPermissions()
                        }
                    )
                }
                
                // Instructions
                VStack(alignment: .leading, spacing: 12) {
                    Text("Setup Instructions")
                        .font(.headline)
                    
                    if !permissionStatus.isValid {
                        InstructionCard(
                            step: 1,
                            title: "Open System Preferences",
                            description: "Click the button below to open Security & Privacy settings"
                        )
                        
                        InstructionCard(
                            step: 2,
                            title: "Navigate to Full Disk Access",
                            description: "Go to Privacy tab → Full Disk Access"
                        )
                        
                        InstructionCard(
                            step: 3,
                            title: "Add OTeePee",
                            description: "Click the + button and add OTeePee.app to the list"
                        )
                        
                        InstructionCard(
                            step: 4,
                            title: "Enable Permission",
                            description: "Check the box next to OTeePee to grant access"
                        )
                    } else {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.title2)
                            
                            VStack(alignment: .leading) {
                                Text("All Set!")
                                    .font(.headline)
                                    .foregroundColor(.green)
                                
                                Text("OTeePee has all required permissions and is ready to monitor for OTP codes.")
                                    .font(.body)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                
                // Action Buttons
                VStack(spacing: 12) {
                    HStack {
                        Button("Open System Preferences") {
                            FilePermissions.openSystemPreferences()
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button("Check Permissions") {
                            refreshPermissionStatus()
                        }
                        .buttonStyle(.bordered)
                        
                        Spacer()
                    }
                    
                    if !permissionStatus.isValid {
                        Button("Show Detailed Instructions") {
                            showingDetailedInstructions.toggle()
                        }
                        .buttonStyle(.bordered)
                        .sheet(isPresented: $showingDetailedInstructions) {
                            DetailedInstructionsView()
                        }
                    }
                }
                
                // Troubleshooting
                if !permissionStatus.isValid {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Troubleshooting")
                            .font(.headline)
                        
                        TroubleshootingRow(
                            icon: "questionmark.circle",
                            title: "Permission not working?",
                            description: "Try restarting OTeePee after granting permissions"
                        )
                        
                        TroubleshootingRow(
                            icon: "exclamationmark.triangle",
                            title: "Can't find OTeePee in the list?",
                            description: "Make sure you're adding from the Applications folder"
                        )
                        
                        TroubleshootingRow(
                            icon: "info.circle",
                            title: "Still having issues?",
                            description: "Check our GitHub repository for more help"
                        )
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            refreshPermissionStatus()
        }
    }
    
    private func refreshPermissionStatus() {
        permissionStatus = FilePermissions.checkPermissionStatus()
    }
    

}

// MARK: - Permission Status Card
struct PermissionStatusCard: View {
    let status: PermissionStatus
    
    var body: some View {
        HStack {
            Image(systemName: status.isValid ? "checkmark.shield.fill" : "exclamationmark.shield.fill")
                .font(.title)
                .foregroundColor(status.isValid ? .green : .orange)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(status.isValid ? "Ready to Go!" : "Permissions Needed")
                    .font(.headline)
                    .foregroundColor(status.isValid ? .green : .orange)
                
                Text(status.description)
                    .font(.body)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            if status.isValid {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.title2)
            }
        }
        .padding()
        .background(status.isValid ? Color.green.opacity(0.1) : Color.orange.opacity(0.1))
        .cornerRadius(8)
    }
}

// MARK: - Permission Row
struct PermissionRow: View {
    let icon: String
    let title: String
    let description: String
    let status: PermissionRowStatus
    let action: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            HStack {
                statusIndicator
                
                if status != .granted {
                    Button("Grant") {
                        action()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                }
            }
        }
        .padding()
        .background(Color.backgroundSecondary)
        .cornerRadius(8)
    }
    
    @ViewBuilder
    private var statusIndicator: some View {
        switch status {
        case .granted:
            Label("Granted", systemImage: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.caption)
        case .required:
            Label("Required", systemImage: "exclamationmark.circle.fill")
                .foregroundColor(.orange)
                .font(.caption)
        case .optional:
            Label("Optional", systemImage: "circle")
                .foregroundColor(.gray)
                .font(.caption)
        }
    }
}

enum PermissionRowStatus {
    case granted, required, optional
}

// MARK: - Instruction Card
struct InstructionCard: View {
    let step: Int
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(step)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(Color.blue)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.backgroundSecondary)
        .cornerRadius(8)
    }
}

// MARK: - Troubleshooting Row
struct TroubleshootingRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.orange)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
        }
    }
}

// MARK: - Detailed Instructions View
struct DetailedInstructionsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Detailed Setup Instructions")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Follow these step-by-step instructions to grant OTeePee the required permissions:")
                        .font(.body)
                        .foregroundColor(.textSecondary)
                    
                    // Detailed steps with images/descriptions
                    ForEach(detailedSteps, id: \.step) { stepData in
                        DetailedInstructionCard(
                            step: stepData.step,
                            title: stepData.title,
                            description: stepData.description,
                            imageName: stepData.imageName
                        )
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Setup Guide")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .frame(width: 600, height: 500)
    }
    
    private var detailedSteps: [(step: Int, title: String, description: String, imageName: String?)] {
        [
            (1, "Open System Preferences", "Click the Apple menu and select 'System Preferences', or use Spotlight search to find it.", nil),
            (2, "Navigate to Security & Privacy", "Click on 'Security & Privacy' in the preferences window.", nil),
            (3, "Go to Privacy Tab", "Click the 'Privacy' tab at the top of the window.", nil),
            (4, "Select Full Disk Access", "In the left sidebar, scroll down and click 'Full Disk Access'.", nil),
            (5, "Unlock Settings", "Click the lock icon in the bottom left and enter your password to make changes.", nil),
            (6, "Add OTeePee", "Click the '+' button and navigate to your Applications folder to select OTeePee.app.", nil),
            (7, "Enable Permission", "Check the box next to OTeePee in the list to grant Full Disk Access.", nil),
            (8, "Restart OTeePee", "Quit and restart OTeePee for the changes to take effect.", nil)
        ]
    }
}

struct DetailedInstructionCard: View {
    let step: Int
    let title: String
    let description: String
    let imageName: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("\(step)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(Color.blue)
                    .clipShape(Circle())
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            Text(description)
                .font(.body)
                .foregroundColor(.textSecondary)
            
            if let imageName = imageName {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 200)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.backgroundSecondary)
        .cornerRadius(12)
    }
}

#Preview {
    PermissionsView()
} 