#!/bin/bash

# Удаляем старые версии
sudo rm -f /opt/cursor.AppImage
sudo rm -f /usr/share/applications/cursor.desktop
sudo rm -f /opt/cursor.png

# Скачиваем последнюю версию
echo "🔄 Downloading Cursor..."
URL=$(wget -qO- "https://www.cursor.com/api/download?platform=linux-x64&releaseTrack=stable" | grep -oP '"downloadUrl":\s*"\K[^"]+')
wget -O /tmp/cursor.AppImage "$URL"

# Устанавливаем AppImage
echo "📦 Installing Cursor..."
sudo mv /tmp/cursor.AppImage /opt/cursor.AppImage
sudo chmod +x /opt/cursor.AppImage

# Скачиваем иконку
echo "🎨 Downloading icon..."
sudo wget -O /opt/cursor.png https://cursor.so/favicon.ico

# Создаем desktop-файл с исправленными параметрами
echo "📝 Creating application entry..."
cat <<EOF | sudo tee /usr/share/applications/cursor.desktop > /dev/null
[Desktop Entry]
Name=Cursor AI
GenericName=AI Code Editor
Comment=The AI-first code editor
Exec=env DESKTOPINTEGRATION=1 /opt/cursor.AppImage --no-sandbox %U
Icon=/opt/cursor.png
Terminal=false
Type=Application
Categories=Development;IDE;Programming;
StartupNotify=true
StartupWMClass=cursor
X-AppImage-Version=1.0
MimeType=text/plain;text/x-chdr;text/x-csrc;text/x-c++hdr;text/x-c++src;
EOF

# Обновляем кэш
echo "♻️ Updating application database..."
sudo update-desktop-database
sudo chmod 644 /usr/share/applications/cursor.desktop

# Создаем симлинк для запуска из терминала
sudo ln -sf /opt/cursor.AppImage /usr/local/bin/cursor

echo -e "\n✅ \033[1;32mInstallation complete!\033[0m"
echo "You can now:"
echo "1. Launch from application menu"
echo "2. Run from terminal with: cursor"
echo "3. Or directly with: /opt/cursor.AppImage"