# OTeePee Distribution Guide 📦

This guide covers everything you need to know about building, signing, and distributing your OTeePee app.

## 🚀 Quick Start

### Building a Release

1. **Run the release build script:**
   ```bash
   ./release_build.sh
   ```

2. **Find your build artifacts in the `build/` directory:**
   - `OTeePee.app` - The application bundle
   - `OTeePee-vX.X.X.dmg` - DMG installer for easy distribution
   - `OTeePee-vX.X.X.zip` - ZIP archive for GitHub releases

## 🔐 Code Signing & Notarization

### For Personal Use (Self-Signed)
Your app will work on your own Mac but will show security warnings on other Macs.

### For Public Distribution (Recommended)

#### 1. Get an Apple Developer Account
- **Cost:** $99/year
- **Benefits:** 
  - Code signing with Developer ID
  - App notarization (removes security warnings)
  - Access to beta software
  - App Store distribution (if desired)

#### 2. Developer ID Certificate Setup
```bash
# Check available certificates
security find-identity -v -p codesigning

# Sign your app (replace with your Developer ID)
codesign --force --deep --sign "Developer ID Application: Your Name (TEAM_ID)" build/Export/OTeePee.app
```

#### 3. Notarization Process
```bash
# Create a notarization-ready archive
ditto -c -k --keepParent build/Export/OTeePee.app OTeePee-notarization.zip

# Submit for notarization (requires app-specific password)
xcrun notarytool submit OTeePee-notarization.zip \
  --apple-id "your-apple-id@example.com" \
  --password "app-specific-password" \
  --team-id "YOUR_TEAM_ID" \
  --wait

# Staple the notarization ticket
xcrun stapler staple build/Export/OTeePee.app
```

## 📋 Distribution Options

### 1. GitHub Releases (Recommended)
**Best for:** Open source projects, easy updates

**Steps:**
1. Create a new release on GitHub
2. Upload the ZIP file from `build/OTeePee-vX.X.X.zip`
3. Write release notes
4. Publish the release

**Download link format:**
```
https://github.com/yourusername/oteepee/releases/latest/download/OTeePee-vX.X.X.zip
```

### 2. Direct Download from Website
**Best for:** Professional distribution, custom landing pages

**Requirements:**
- Web hosting
- HTTPS (required for downloads)
- Optional: Download analytics

### 3. Mac App Store
**Best for:** Maximum reach, automatic updates

**Requirements:**
- Apple Developer Account ($99/year)
- App Store review process
- Compliance with App Store guidelines
- Sandboxing requirements

### 4. Third-Party Platforms
- **Homebrew Cask:** For developer-friendly distribution
- **MacUpdate, Softonic:** For broader reach

## 🛡️ Security Considerations

### Gatekeeper Compatibility
- **Signed + Notarized:** No warnings, best user experience
- **Signed only:** Warning dialog, user can override
- **Unsigned:** Multiple warnings, harder for users to install

### User Instructions for Unsigned Apps
If you distribute without a Developer ID:

1. **First launch warning:**
   - Right-click the app → "Open"
   - Click "Open" in the dialog

2. **Alternative method:**
   - System Preferences → Security & Privacy → General
   - Click "Open Anyway" next to the blocked app

## 📊 Distribution Strategies

### Free Distribution
```markdown
## Download OTeePee

### Latest Release
[Download OTeePee v1.0.0](https://github.com/yourusername/oteepee/releases/latest/download/OTeePee-v1.0.0.zip)

### Installation
1. Download the ZIP file
2. Extract and drag OTeePee.app to Applications
3. Launch and grant required permissions
```

### Professional Distribution
- Custom website with download page
- Email capture for updates
- Analytics tracking
- Automatic update checking

## 🔄 Update Mechanisms

### Manual Updates
Users download new versions manually from your distribution channel.

### Automatic Updates (Advanced)
Implement using frameworks like:
- **Sparkle:** Popular macOS update framework
- **Custom solution:** Check for updates via API

## 📈 Analytics & Metrics

### Basic Tracking
- GitHub release download counts
- Website download analytics
- User feedback via GitHub issues

### Advanced Tracking
- Crash reporting (e.g., Sentry)
- Usage analytics (with user consent)
- Feature usage metrics

## 🚨 Common Issues & Solutions

### "App is damaged" Error
**Cause:** Quarantine attribute from download
**Solution:**
```bash
xattr -cr /Applications/OTeePee.app
```

### Permission Denied
**Cause:** App not signed or notarized
**Solution:** Follow code signing steps above

### App Won't Launch
**Cause:** Missing dependencies or permissions
**Solution:** Check Console.app for error messages

## 📝 Legal Considerations

### Open Source License
Your app uses the MIT License, which allows:
- ✅ Commercial use
- ✅ Modification
- ✅ Distribution
- ✅ Private use

### Privacy Policy
Consider adding a privacy policy that covers:
- iMessage database access
- Local data processing
- No data transmission

### Terms of Service
Optional but recommended for professional distribution.

## 🎯 Marketing Your App

### App Description Template
```
OTeePee - Automatic OTP Detection for macOS

Tired of manually copying OTP codes from your iPhone to your Mac? 
OTeePee automatically detects OTP codes in your iMessage and copies 
them to your clipboard instantly.

✨ Features:
• Automatic OTP detection from iMessage
• Instant clipboard copying
• Privacy-first (everything stays local)
• Native macOS integration
• Menu bar convenience

🔒 Privacy & Security:
• All processing happens locally on your Mac
• No data ever leaves your device
• Open source for transparency
```

### Social Media
- Tweet about releases
- Post on Reddit (r/MacApps, r/productivity)
- Share in relevant Discord/Slack communities

## 📞 Support Strategy

### Documentation
- Comprehensive README
- FAQ section
- Video tutorials (optional)

### Support Channels
- GitHub Issues for bugs
- Discussions for questions
- Email for private inquiries

### Community Building
- Encourage contributions
- Respond to feedback promptly
- Regular updates and improvements

---

## 🎉 Ready to Distribute?

1. **Test thoroughly** on different macOS versions
2. **Choose your distribution method** (GitHub Releases recommended)
3. **Consider code signing** for better user experience
4. **Create compelling app description**
5. **Launch and gather feedback**

Good luck with your app distribution! 🚀 