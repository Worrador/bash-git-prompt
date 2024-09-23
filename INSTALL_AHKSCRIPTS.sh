#!/bin/bash

# Define variables
AHK_URL="https://www.autohotkey.com/download/ahk-install.exe"
AHK_INSTALLER="ahk-install.exe"
AHK_FILE="GitBashBorderless.ahk"
STARTUP_FOLDER="$APPDATA\\Microsoft\\Windows\\Start Menu\\Programs\\Startup"

# Check if AutoHotkey is installed
if ! command -v AutoHotkey > /dev/null 2>&1; then
    echo "AutoHotkey not found. Installing..."

    # Download the AutoHotkey installer
    if [ ! -f "$AHK_INSTALLER" ]; then
        curl -O "$AHK_URL"
    fi

    # Run the installer silently
    "$AHK_INSTALLER" /S
else
    echo "AutoHotkey is already installed."
fi

# Copy the GitBashBorderless.ahk file to the startup folder
if [ -f "$AHK_FILE" ]; then
    echo "Copying $AHK_FILE to Startup folder..."
    cp "$AHK_FILE" "$STARTUP_FOLDER"
    echo "AutoHotkey script copied to startup folder."
else
    echo "Error: $AHK_FILE not found."
fi
