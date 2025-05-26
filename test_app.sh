#!/bin/bash

# Test script for OTeePee app

echo "🔧 OTeePee Test Helper"
echo "====================="

APP_PATH="$HOME/Library/Developer/Xcode/DerivedData/OTeePee-*/Build/Products/Debug/OTeePee.app"

# Find the actual app path
ACTUAL_APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "OTeePee.app" -type d 2>/dev/null | head -1)

if [ -z "$ACTUAL_APP_PATH" ]; then
    echo "❌ App not found. Please build the project first."
    exit 1
fi

echo "📱 Found app at: $ACTUAL_APP_PATH"

# Menu
echo ""
echo "Choose an option:"
echo "1. Launch app (normal)"
echo "2. Reset onboarding and launch"
echo "3. Copy app to Desktop"
echo "4. Remove quarantine and launch"
echo "5. Quit"

read -p "Enter choice (1-5): " choice

case $choice in
    1)
        echo "🚀 Launching app..."
        open "$ACTUAL_APP_PATH"
        ;;
    2)
        echo "🔄 Resetting onboarding..."
        defaults delete com.yourcompany.oteepee hasCompletedOnboarding 2>/dev/null || true
        echo "🚀 Launching app with fresh onboarding..."
        open "$ACTUAL_APP_PATH"
        ;;
    3)
        echo "📋 Copying app to Desktop..."
        cp -R "$ACTUAL_APP_PATH" ~/Desktop/OTeePee_Test.app
        echo "✅ App copied to ~/Desktop/OTeePee_Test.app"
        ;;
    4)
        echo "🔓 Removing quarantine attributes..."
        xattr -cr "$ACTUAL_APP_PATH"
        echo "🚀 Launching app..."
        open "$ACTUAL_APP_PATH"
        ;;
    5)
        echo "👋 Goodbye!"
        exit 0
        ;;
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac

echo "✅ Done!" 