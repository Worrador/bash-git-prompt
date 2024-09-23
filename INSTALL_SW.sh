#!/bin/bash

# Function to browse for a directory using PowerShell
browse_directory() {
    powershell -Command "Add-Type -AssemblyName System.Windows.Forms; \$folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog; \$folderBrowser.Description = 'Select installation directory'; \$folderBrowser.RootFolder = 'MyComputer'; if(\$folderBrowser.ShowDialog() -eq 'OK') { Write-Host \$folderBrowser.SelectedPath }"
}

# Install Scoop if not present
if ! command -v scoop &> /dev/null; then

    # Prompt user to browse for installation directory
    echo "Please select the installation directory:"
    install_dir=$(browse_directory)

    # Validate and create the directory if it doesn't exist
    if [ ! -z "$install_dir" ]; then
        if [ ! -d "$install_dir" ]; then
            mkdir -p "$install_dir"
        fi
        # Convert to Windows path style (double backslashes for Windows paths in Bash)
        install_dir=$(echo "$install_dir" | sed 's/\//\\/g')
        echo "Installation directory set to: $install_dir"

        # Set the SCOOP environment variable to the selected directory in PowerShell
        powershell -Command "[Environment]::SetEnvironmentVariable('SCOOP', '$install_dir', [System.EnvironmentVariableTarget]::User)"

    else
        echo "No directory selected. Using default installation paths for each software."
        exit 1
    fi

    echo "Installing Scoop..."
    powershell -Command "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh'))"
    export PATH="$install_dir/shims:$PATH"
else
    echo "Scoop is already installed."
    scoop_dir=$(powershell -Command "[Environment]::GetEnvironmentVariable('SCOOP', [System.EnvironmentVariableTarget]::User)")
    echo "Installation directory is set to: $scoop_dir. Uninstall scoop to change that"
fi


# Set Scoop installation directory
powershell -Command "[Environment]::SetEnvironmentVariable('SCOOP','"$install_dir"',[System.EnvironmentVariableTarget]::User)"

# Configure Scoop to use the selected installation directory
scoop config root "$install_dir"

# Function to install software with Scoop
install_software() {
    local software=$1
    if ! scoop list | grep -q "^$software "; then
        read -p "Do you want to install $software? (y/n): " choice
        case "$choice" in 
            y|Y )
                echo "Installing $software..."
                scoop install $software
                ;;
            * )
                echo "Skipping installation of $software."
                ;;
        esac
    else
        echo "$software is already installed."
    fi
}

# Add necessary buckets
scoop bucket add extras
scoop bucket add versions
scoop bucket add java
scoop bucket add nerd-fonts

# Core development tools
install_software git
install_software mingw
install_software cmake
install_software make
install_software ninja
install_software gdb
install_software llvm

# Package managers and build tools
install_software vcpkg
install_software conan

# Programming languages and runtimes
install_software python
install_software nodejs

# IDEs and text editors
install_software vscode
install_software notepadplusplus

# Version control and CLI tools
install_software gh

# Containerization and virtualization
# Note: Docker might require manual installation as it's not typically managed by Scoop
echo "Docker installation might require manual steps. Please visit https://docs.docker.com/desktop/windows/install/ for instructions."

# Debugging tools
# Note: WinDbg might not be available through Scoop
echo "WinDbg might require manual installation. Please visit https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger/debugger-download-tools for instructions."

# Data science and notebooks
install_software jupyter

# Terminal and system utilities
install_software windows-terminal
install_software 7zip

# Browsers
install_software brave

# Media players
install_software vlc

# Archivers
install_software winrar

echo "All installations checked!"

# Keep the window open
read -p "Press [Enter] to exit."
