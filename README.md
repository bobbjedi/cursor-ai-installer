# Cursor AI Editor Installer for Linux

![Cursor AI Logo](https://cursor.so/favicon.ico)

A one-command installer for the Cursor AI code editor on Linux systems. Automatically downloads the latest stable AppImage release, verifies its integrity, installs it system-wide, sets up a desktop launcher with an icon, and creates a terminal command alias. Ensures seamless updates and desktop integration for an AI-powered coding experience.

## Features

- Automatic download of latest Cursor version
- Dependency auto-installation (libfuse2)
- Desktop icon and menu integration
- Terminal command shortcut
- Clean uninstall option

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/cursor-ai-installer.git
cd cursor-ai-installer
```
2. Run the installer
```bash
chmod +x install_or_update.sh
sudo ./install_or_update.sh
```

## Usage
### After installation:

- Launch from your application menu

- Run from terminal: cursor

- Run directly: /opt/cursor.AppImage

## Uninstallation
### To completely remove:

```bash
sudo ./uninstall.sh
```

## Requirements
### Linux (tested on Ubuntu/Debian)

```
wget, libfuse2
```

Internet connection

License MIT © 