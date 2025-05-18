#!/usr/bin/env bash

# Configuration
TEMP_APPIMAGE="/tmp/cursor.AppImage"
VERSION_FILE="/tmp/cursor.version"
TARGET_APPIMAGE="/opt/cursor.AppImage"
TARGET_ICON="/opt/cursor.png"
DESKTOP_FILE="/usr/share/applications/cursor.desktop"
MIN_SIZE=$((100*1024*1024))  # 100MB minimum size

# Get latest version info
echo "🔄 Checking for updates..."
API_RESPONSE=$(wget -qO- "https://www.cursor.com/api/download?platform=linux-x64&releaseTrack=stable")
LATEST_VERSION=$(echo "$API_RESPONSE" | grep -o '"version": *"[^"]*"' | head -n1 | cut -d'"' -f4)
DOWNLOAD_URL=$(echo "$API_RESPONSE" | grep -o '"downloadUrl": *"[^"]*"' | head -n1 | cut -d'"' -f4)

# Check if update needed
if [ -f "$VERSION_FILE" ] && [ -f "$TARGET_APPIMAGE" ]; then
    CURRENT_VERSION=$(cat "$VERSION_FILE" | tr -d '[:space:]')

    if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
        echo "✅ Already running latest version ($LATEST_VERSION). No update needed."
        exit 0
    fi
    echo "🔍 New version available: $LATEST_VERSION (Current: $CURRENT_VERSION)"
else
    echo "🔍 Installing Cursor $LATEST_VERSION (first-time install)"
fi

# Download new version
echo "⬇️ Downloading Cursor $LATEST_VERSION..."
rm -f "$TEMP_APPIMAGE"
wget -O "$TEMP_APPIMAGE" "$DOWNLOAD_URL"

# File verification
if [ ! -f "$TEMP_APPIMAGE" ]; then
    echo "❌ Download failed! Installation aborted."
    exit 1
fi

if ! file "$TEMP_APPIMAGE" | grep -q "ELF"; then
    echo "❌ Downloaded file is not a valid AppImage (not ELF executable)!"
    rm -f "$TEMP_APPIMAGE"
    exit 1
fi

FILE_SIZE=$(stat -c%s "$TEMP_APPIMAGE")
if [ "$FILE_SIZE" -lt "$MIN_SIZE" ]; then
    echo "❌ Downloaded file is too small ($((FILE_SIZE/1024/1024)) MB), likely incomplete!"
    rm -f "$TEMP_APPIMAGE"
    exit 1
fi

echo "✅ File verified: $((FILE_SIZE/1024/1024)) MB, ELF executable"

# Remove old versions
sudo rm -f "$TARGET_APPIMAGE" "$DESKTOP_FILE" "$TARGET_ICON"

# Install new version
echo "📦 Installing Cursor $LATEST_VERSION..."
sudo mv "$TEMP_APPIMAGE" "$TARGET_APPIMAGE"
sudo chmod +x "$TARGET_APPIMAGE"

# Save version info
echo "$LATEST_VERSION" | sudo tee "$VERSION_FILE" > /dev/null

# Handle icon
echo "🎨 Setting up icon..."
if [ -f "cursor-logo.png" ]; then
    sudo cp cursor-logo.png "$TARGET_ICON" || echo "⚠️ Could not copy local icon"
else
    sudo wget -O "$TARGET_ICON" https://raw.githubusercontent.com/getcursor/cursor/main/packages/desktop/static/icon-256.png || \
    echo "⚠️ Could not download default icon"
fi

# Create desktop entry
echo "📝 Creating application entry..."
cat <<EOF | sudo tee "$DESKTOP_FILE" > /dev/null
[Desktop Entry]
Name=Cursor AI
GenericName=AI Code Editor
Comment=The AI-first code editor
Exec=env DESKTOPINTEGRATION=1 $TARGET_APPIMAGE --no-sandbox %U
Icon=$TARGET_ICON
Terminal=false
Type=Application
Categories=Development;IDE;Programming;
StartupNotify=true
StartupWMClass=cursor
X-AppImage-Version=$LATEST_VERSION
MimeType=text/plain;text/x-chdr;text/x-csrc;text/x-c++hdr;text/x-c++src;
EOF

# Final setup
echo "♻️ Finalizing installation..."
sudo chmod 644 "$DESKTOP_FILE"
[ -f "$TARGET_ICON" ] && sudo chmod 644 "$TARGET_ICON"
sudo update-desktop-database
sudo ln -sf "$TARGET_APPIMAGE" /usr/local/bin/cursor

# Completion message
echo
echo "✅ Cursor AI $LATEST_VERSION installed successfully!"
echo
echo "Launch options:"
echo "1. Application menu"
echo "2. Terminal command: cursor"
echo "3. Direct path: $TARGET_APPIMAGE"
