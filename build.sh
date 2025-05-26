#!/bin/bash

# OTeePee Build Script
# This script builds the OTeePee macOS app

set -e

echo "🔐 Building OTeePee..."

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Error: Xcode command line tools are not installed."
    echo "Please install Xcode from the App Store or run: xcode-select --install"
    exit 1
fi

# Build the project
echo "📦 Building project..."
xcodebuild -project OTeePee.xcodeproj -scheme OTeePee -configuration Release build

echo "✅ Build completed successfully!"
echo ""
echo "📍 The built app can be found in:"
echo "   build/Release/OTeePee.app"
echo ""
echo "🚀 To install:"
echo "   1. Copy OTeePee.app to your Applications folder"
echo "   2. Launch the app"
echo "   3. Grant Full Disk Access permission in System Preferences"
echo "   4. Start monitoring for OTP codes!"
echo ""
echo "📖 For more information, see README.md" 