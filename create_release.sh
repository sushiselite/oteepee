#!/bin/bash

# OTeePee Release Creation Script
# This script helps create a new release with proper tagging

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    print_error "This script must be run from the root of a git repository"
    exit 1
fi

# Check if working directory is clean
if [ -n "$(git status --porcelain)" ]; then
    print_warning "Working directory is not clean. Please commit or stash changes first."
    git status --short
    exit 1
fi

# Get current version from Info.plist
CURRENT_VERSION=$(defaults read "$(pwd)/OTeePee/Resources/Info.plist" CFBundleShortVersionString 2>/dev/null || echo "1.0")

print_status "Current version: $CURRENT_VERSION"

# Ask for new version
echo -n "Enter new version (current: $CURRENT_VERSION): "
read NEW_VERSION

if [ -z "$NEW_VERSION" ]; then
    print_error "Version cannot be empty"
    exit 1
fi

# Validate version format (basic check)
if ! [[ $NEW_VERSION =~ ^[0-9]+\.[0-9]+(\.[0-9]+)?$ ]]; then
    print_error "Invalid version format. Use semantic versioning (e.g., 1.0.0)"
    exit 1
fi

# Check if tag already exists
if git tag | grep -q "^v$NEW_VERSION$"; then
    print_error "Tag v$NEW_VERSION already exists"
    exit 1
fi

# Update version in Info.plist
print_status "Updating version in Info.plist..."
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $NEW_VERSION" OTeePee/Resources/Info.plist

# Update build number to current timestamp
BUILD_NUMBER=$(date +%Y%m%d%H%M)
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $BUILD_NUMBER" OTeePee/Resources/Info.plist

print_status "Updated to version $NEW_VERSION (build $BUILD_NUMBER)"

# Commit version changes
print_status "Committing version changes..."
git add OTeePee/Resources/Info.plist
git commit -m "Bump version to $NEW_VERSION"

# Create and push tag
print_status "Creating tag v$NEW_VERSION..."
git tag -a "v$NEW_VERSION" -m "Release version $NEW_VERSION"

print_status "Pushing changes and tag..."
git push origin main
git push origin "v$NEW_VERSION"

print_success "🎉 Release v$NEW_VERSION created successfully!"
print_status "GitHub Actions will automatically build and create the release."
print_status "Check the Actions tab on GitHub to monitor the build progress."

echo ""
echo "📋 What happens next:"
echo "1. GitHub Actions will build the app"
echo "2. Create a release on GitHub"
echo "3. Upload ZIP and DMG files"
echo "4. Users can download from the releases page"

echo ""
echo "🔗 Useful links:"
echo "- Releases: https://github.com/yourusername/oteepee/releases"
echo "- Actions: https://github.com/yourusername/oteepee/actions" 