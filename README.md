# Cursor AI Editor Installer for Linux

![Cursor AI Logo](https://cursor.so/favicon.ico)

A one-command installer for Cursor AI code editor on Linux systems. Automates the download, installation, and desktop integration of the latest Cursor AppImage.

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
chmod +x install.sh
sudo ./install.sh
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