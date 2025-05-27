# OTeePee 🔐

**Automatic OTP Detection & Clipboard Copy for macOS**

OTeePee is a native macOS application that automatically monitors your iMessage for incoming OTP (One-Time Password) codes and copies them directly to your clipboard with a helpful notification. Perfect for seamless 2FA authentication in any browser or application.

> 🌐 **[View Landing Page](landing-page/)** | 📖 **[Deployment Guide](LANDING_PAGE_DEPLOYMENT.md)**

## ✨ Features

- **Automatic OTP Detection**: Monitors iMessage for incoming SMS/text messages containing OTP codes
- **Instant Clipboard Copy**: Automatically copies detected OTPs to your clipboard
- **Smart Pattern Recognition**: Recognizes various OTP formats (4-8 digit codes, alphanumeric codes)
- **Native macOS Integration**: Built with Swift using native macOS frameworks
- **Privacy First**: Everything happens locally - no data ever leaves your device
- **Menu Bar App**: Lightweight menu bar application that runs in the background
- **Notification Support**: Shows native macOS notifications when OTPs are detected

## 🚀 Quick Start

### Prerequisites

- macOS 15.0 (Sequoia) or later

### Download & Installation

#### Option 1: Download Release (Recommended)
1. **[Download the latest release](https://github.com/sushiselite/oteepee/releases/latest)** 
2. **Choose your preferred format:**
   - `OTeePee-vX.X.X.zip` - ZIP archive (recommended for most users)
   - `OTeePee-vX.X.X.dmg` - Disk image with installer
3. **Extract and install:**
   - For ZIP: Extract and drag `OTeePee.app` to your Applications folder
   - For DMG: Open the disk image and drag the app to Applications
4. **Launch the app** and grant the required permissions (see below)

#### Option 2: Build from Source
Requirements: Xcode 12.0 or later

```bash
# Clone and build
git clone https://github.com/sushiselite/oteepee.git
cd oteepee
./release_build.sh
```

### Required Permissions

OTeePee requires the following permissions to function:

1. **Full Disk Access**: Required to read the iMessage database
   - Go to System Preferences → Security & Privacy → Privacy → Full Disk Access
   - Click the lock to make changes and add OTeePee

2. **Accessibility**: Required for menu bar functionality
   - Go to System Preferences → Security & Privacy → Privacy → Accessibility
   - Add OTeePee to the list

## 🛠 Development

### Building from Source

```bash
# Clone the repository
git clone https://github.com/sushiselite/oteepee.git
cd oteepee

# Open in Xcode
open OTeePee.xcodeproj

# Build and run (Cmd+R)
```

### Project Structure

```
OTeePee/
├── OTeePee/                 # Main app target
│   ├── App/                 # App lifecycle and main entry point
│   ├── Services/            # Core services (iMessage monitor, OTP parser)
│   ├── Utils/               # Utility classes and extensions
│   ├── Views/               # SwiftUI views
│   └── Resources/           # Assets, Info.plist, etc.
├── OTeePeeTests/            # Unit tests
└── README.md
```

### Key Components

- **MessageMonitor**: Monitors the iMessage SQLite database for new messages
- **OTPParser**: Extracts OTP codes from message text using regex patterns
- **ClipboardManager**: Handles copying OTPs to the system clipboard
- **NotificationManager**: Shows native macOS notifications

## 🔒 Privacy & Security

- **Local Processing**: All OTP detection and processing happens locally on your device
- **No Network Access**: The app doesn't make any network requests
- **No Data Collection**: We don't collect, store, or transmit any of your data
- **Open Source**: The entire codebase is open source for transparency

## 📋 Supported OTP Formats

OTeePee recognizes various OTP formats commonly used by services:

- 4-8 digit numeric codes (e.g., `123456`, `12345678`)
- Alphanumeric codes (e.g., `A1B2C3`)
- Codes with specific keywords (e.g., "Your verification code is 123456")
- Service-specific patterns (Apple, Google, Twitter, etc.)

## 🐛 Troubleshooting

### App Not Detecting OTPs

1. Ensure Full Disk Access permission is granted
2. Check that iMessage is enabled and receiving messages
3. Verify the message contains a recognizable OTP pattern

### Clipboard Not Working

1. Check Accessibility permissions
2. Restart the app
3. Try manually copying something else to test clipboard functionality

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development Setup

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by the original [ohtipi](https://github.com/YacTeam/ohtipi) project
- Built with ❤️ for the macOS community

## ⚠️ Disclaimer

This app accesses your iMessage database to detect OTP codes. While all processing happens locally, please ensure you trust this software before granting the required permissions. The developers are not responsible for any data loss or security issues. 