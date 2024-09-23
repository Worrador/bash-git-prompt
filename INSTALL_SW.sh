#!/bin/bash

# Function to check if the script is running as administrator
is_admin() {
    net session > /dev/null 2>&1
    return $?
}

# Function to elevate privileges
elevate_privileges() {
    echo "Requesting administrator privileges..."
    powershell -Command "Start-Process cmd -Verb RunAs -ArgumentList '/c',\"$0\""
    exit 0
}

# Function to browse for a directory
browse_directory() {
    powershell -Command "Add-Type -AssemblyName System.Windows.Forms; \$folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog; \$folderBrowser.Description = 'Select installation directory'; \$folderBrowser.RootFolder = 'MyComputer'; if(\$folderBrowser.ShowDialog() -eq 'OK') { Write-Host \$folderBrowser.SelectedPath }"
}

# Check for admin privileges and elevate if necessary
if ! is_admin; then
    elevate_privileges
fi

# Now the script is running with admin privileges
echo "The script is running with administrative privileges!"

# Prompt user to browse for installation directory
echo "Please select the installation directory:"
install_dir=$(browse_directory)

# Validate and create the directory if it doesn't exist
if [ ! -z "$install_dir" ]; then
    if [ ! -d "$install_dir" ]; then
        mkdir -p "$install_dir"
    fi
    # Convert to Windows path style
    install_dir=$(echo "$install_dir" | sed 's/\//\\/g')
    echo "Installation directory set to: $install_dir"
else
    echo "No directory selected. Using default installation paths for each software."
fi

# Function to check if a command is available
is_installed() {
    command -v "$1" > /dev/null 2>&1
}

# Install Chocolatey if not present
if ! is_installed choco; then
    echo "Installing Chocolatey..."
    powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command \
    "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
    
    # Determine Chocolatey installation path
    choco_path=$(powershell -Command "[System.Environment]::GetEnvironmentVariable('ChocolateyInstall', 'Machine')")
    
    if [ -n "$choco_path" ]; then
        # Add Chocolatey to PATH
        export PATH="$PATH:$choco_path/bin"
        echo "Chocolatey installed. Added to PATH: $choco_path/bin"
    else
        echo "Warning: Couldn't determine Chocolatey installation path."
    fi
else
    echo "Chocolatey is already installed."
fi

# Function to install software with custom path and user prompt
install_software() {
    local software=$1
    local command=$2
    if ! is_installed $command; then
        read -p "Do you want to install $software? (y/n): " choice
        case "$choice" in 
            y|Y )
                echo "Installing $software..."
                if [ ! -z "$install_dir" ]; then
                    choco install $software -y --install-directory="$install_dir"
                else
                    choco install $software -y
                fi
                ;;
            * )
                echo "Skipping installation of $software."
                ;;
        esac
    else
        echo "$software is already installed."
    fi
}
# Core development tools
install_software git git
install_software mingw mingw
install_software cmake cmake
install_software make make
install_software ninja ninja
install_software gdb gdb
install_software llvm clang

# Package managers and build tools
install_software vcpkg vcpkg
install_software conan conan

# Programming languages and runtimes
install_software python3 python
install_software python-pip pip
install_software nodejs node

# IDEs and text editors
install_software vscode code
install_software notepadplusplus notepad++

# Version control and CLI tools
install_software gh gh

# Containerization and virtualization
install_software docker docker

# Debugging tools
install_software windbg windbg

# Data science and notebooks
install_software jupyter jupyter

# Terminal and system utilities
install_software microsoft-windows-terminal wt
install_software 7zip 7z

# Browsers
install_software brave brave

# Media players
install_software vlc vlc

# Archivers
install_software winrar winrar

echo "All installations checked!"

# Keep the window open
read -p "Press [Enter] to exit."