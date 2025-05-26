#!/bin/bash

# OTeePee Release Build Script
# This script builds a release version of OTeePee for distribution

set -e  # Exit on any error

echo "🚀 Starting OTeePee Release Build Process..."

# Configuration
PROJECT_NAME="OTeePee"
SCHEME_NAME="OTeePee"
CONFIGURATION="Release"
BUILD_DIR="build"
ARCHIVE_PATH="$BUILD_DIR/$PROJECT_NAME.xcarchive"
EXPORT_PATH="$BUILD_DIR/Export"
APP_NAME="$PROJECT_NAME.app"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the right directory
if [ ! -f "$PROJECT_NAME.xcodeproj/project.pbxproj" ]; then
    print_error "Could not find $PROJECT_NAME.xcodeproj in current directory"
    print_error "Please run this script from the project root directory"
    exit 1
fi

# Clean previous builds
print_status "Cleaning previous builds..."
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Check Xcode version
print_status "Checking Xcode version..."
xcodebuild -version

# Build and archive the project
print_status "Building and archiving $PROJECT_NAME..."
xcodebuild archive \
    -project "$PROJECT_NAME.xcodeproj" \
    -scheme "$SCHEME_NAME" \
    -configuration "$CONFIGURATION" \
    -archivePath "$ARCHIVE_PATH" \
    -destination "generic/platform=macOS" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES

if [ $? -eq 0 ]; then
    print_success "Archive created successfully at $ARCHIVE_PATH"
else
    print_error "Archive failed"
    exit 1
fi

# Export the app
print_status "Exporting application..."

# Create export options plist
cat > "$BUILD_DIR/ExportOptions.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>mac-application</string>
    <key>destination</key>
    <string>export</string>
    <key>stripSwiftSymbols</key>
    <true/>
</dict>
</plist>
EOF

xcodebuild -exportArchive \
    -archivePath "$ARCHIVE_PATH" \
    -exportPath "$EXPORT_PATH" \
    -exportOptionsPlist "$BUILD_DIR/ExportOptions.plist"

if [ $? -eq 0 ]; then
    print_success "Export completed successfully"
else
    print_error "Export failed"
    exit 1
fi

# Check if the app was created
if [ -d "$EXPORT_PATH/$APP_NAME" ]; then
    print_success "Application built successfully: $EXPORT_PATH/$APP_NAME"
    
    # Get app info
    APP_VERSION=$(defaults read "$(pwd)/$EXPORT_PATH/$APP_NAME/Contents/Info.plist" CFBundleShortVersionString 2>/dev/null || echo "Unknown")
    APP_BUILD=$(defaults read "$(pwd)/$EXPORT_PATH/$APP_NAME/Contents/Info.plist" CFBundleVersion 2>/dev/null || echo "Unknown")
    
    print_status "App Version: $APP_VERSION"
    print_status "Build Number: $APP_BUILD"
    
    # Create a DMG for distribution
    print_status "Creating DMG for distribution..."
    DMG_NAME="$PROJECT_NAME-v$APP_VERSION.dmg"
    DMG_PATH="$BUILD_DIR/$DMG_NAME"
    
    # Create temporary directory for DMG contents
    DMG_TEMP_DIR="$BUILD_DIR/dmg_temp"
    mkdir -p "$DMG_TEMP_DIR"
    
    # Copy app to temp directory
    cp -R "$EXPORT_PATH/$APP_NAME" "$DMG_TEMP_DIR/"
    
    # Create Applications symlink
    ln -s /Applications "$DMG_TEMP_DIR/Applications"
    
    # Create DMG
    hdiutil create -volname "$PROJECT_NAME v$APP_VERSION" \
        -srcfolder "$DMG_TEMP_DIR" \
        -ov -format UDZO \
        "$DMG_PATH"
    
    if [ $? -eq 0 ]; then
        print_success "DMG created: $DMG_PATH"
    else
        print_warning "DMG creation failed, but app is available at $EXPORT_PATH/$APP_NAME"
    fi
    
    # Clean up temp directory
    rm -rf "$DMG_TEMP_DIR"
    
    # Create ZIP for GitHub releases
    print_status "Creating ZIP archive for GitHub releases..."
    ZIP_NAME="$PROJECT_NAME-v$APP_VERSION.zip"
    ZIP_PATH="$BUILD_DIR/$ZIP_NAME"
    
    cd "$EXPORT_PATH"
    zip -r "../$ZIP_NAME" "$APP_NAME"
    cd - > /dev/null
    
    if [ -f "$ZIP_PATH" ]; then
        print_success "ZIP archive created: $ZIP_PATH"
    fi
    
    # Display file sizes
    print_status "Build artifacts:"
    if [ -f "$DMG_PATH" ]; then
        DMG_SIZE=$(du -h "$DMG_PATH" | cut -f1)
        echo "  📦 DMG: $DMG_NAME ($DMG_SIZE)"
    fi
    if [ -f "$ZIP_PATH" ]; then
        ZIP_SIZE=$(du -h "$ZIP_PATH" | cut -f1)
        echo "  📦 ZIP: $ZIP_NAME ($ZIP_SIZE)"
    fi
    
    # Check code signing
    print_status "Checking code signing..."
    codesign -dv --verbose=4 "$EXPORT_PATH/$APP_NAME" 2>&1 | head -10
    
    # Verify the app
    print_status "Verifying application..."
    if spctl -a -t exec -vv "$EXPORT_PATH/$APP_NAME" 2>&1 | grep -q "accepted"; then
        print_success "Application passes Gatekeeper verification"
    else
        print_warning "Application may not pass Gatekeeper verification"
        print_warning "You may need to sign with a Developer ID certificate"
    fi
    
else
    print_error "Application not found at expected location: $EXPORT_PATH/$APP_NAME"
    exit 1
fi

print_success "🎉 Release build completed successfully!"
print_status "Build artifacts are available in the '$BUILD_DIR' directory"

echo ""
echo "📋 Next Steps for Distribution:"
echo "1. Test the app thoroughly on different macOS versions"
echo "2. For public distribution, consider getting a Developer ID certificate"
echo "3. Upload to GitHub Releases or your preferred distribution method"
echo "4. Update your README with download instructions" 