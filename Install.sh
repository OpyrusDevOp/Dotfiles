#!/bin/bash

#==============================================================================
# Arch Linux System Setup Script
# Description: Automated installation and configuration script
#==============================================================================

set -euo pipefail  # Exit on error

#------------------------------------------------------------------------------
# Configuration Variables
#------------------------------------------------------------------------------
readonly DOTNET_INSTALL_URL="https://dot.net/v1/dotnet-install.sh"
readonly BUN_INSTALL_URL="https://bun.sh/install"
readonly NEOVIM_CONFIG_REPO="https://github.com/OpyrusDevOp/Neovim-Config.git"
readonly YAY_REPO="https://aur.archlinux.org/yay.git"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
#------------------------------------------------------------------------------
# Utility Functions
#------------------------------------------------------------------------------

# Print colored messages
print_header() {
    echo -e "\n\033[1;34m#### $1 ####\033[0m"
}

print_info() {
    echo -e "\033[1;32m[INFO]\033[0m $1"
}

print_error() {
    echo -e "\033[1;31m[ERROR]\033[0m $1" >&2
}

# Display installation message
display_install_msg() {
    print_info "Installing $1..."
}

#------------------------------------------------------------------------------
# Installation Functions
#------------------------------------------------------------------------------

# Install package using pacman
install_pacman() {
    local description="$1"
    local package="$2"
    
    display_install_msg "$description"
    sudo pacman -S --noconfirm --needed $package || {
        print_error "Failed to install $description"
        return 1
    }
}

# Install package using yay (AUR helper)
install_yay() {
    local description="$1"
    local package="$2"
    
    display_install_msg "$description"
    yay -S --noconfirm --needed $package || {
        print_error "Failed to install $description"
        return 1
    }
}

# Install .NET SDK
install_dotnet() {
    display_install_msg "Dotnet SDK"
    
    local install_script="dotnet-install.sh"
    curl -fsSL "$DOTNET_INSTALL_URL" -o "$install_script"
    chmod +x "$install_script"
    ./"$install_script" --version latest
    rm -f "$install_script"
}

# Install Bun runtime
install_bun() {
    display_install_msg "Bun Runtime"
    curl -fsSL "$BUN_INSTALL_URL" | bash
}

# Setup Neovim configuration
setup_neovim_config() {
    print_info "Setting up Neovim configuration..."
    
    local nvim_config_dir="$HOME/.config/nvim"
    
    if [[ -d "$nvim_config_dir" ]]; then
        print_info "Backing up existing Neovim config..."
        mv "$nvim_config_dir" "${nvim_config_dir}.backup.$(date +%s)"
    fi
    
    git clone "$NEOVIM_CONFIG_REPO" "$nvim_config_dir"
}

# Install Yay AUR helper
install_yay_helper() {
    print_info "Installing Yay AUR helper..."
    
    # Install dependencies
    sudo pacman -S --noconfirm --needed git base-devel
    
    # Clone and build yay
    local temp_dir
    temp_dir=$(mktemp -d)
    cd "$temp_dir"
    git clone "$YAY_REPO"
    cd yay
    makepkg -si --noconfirm
    cd ~
    rm -rf "$temp_dir"
}

#------------------------------------------------------------------------------
# Main Installation Sections
#------------------------------------------------------------------------------

# Update system
update_system() {
    print_header "System Update"
    sudo pacman -Syu --noconfirm
}

# Install all packages
install_packages() {
    print_header "Package Installation"
    
    # Core tools
    install_pacman "Git" "git"
    
    # Setup Neovim early
    setup_neovim_config
    
    # Install AUR helper
    install_yay_helper
    
    # Terminal & Shell
    install_pacman "Terminal (Kitty)" "kitty"
    install_pacman "Neovim" "neovim"
    install_pacman "Fish Shell" "fish"
    
    # Browsers & Applications
    install_yay "Zen Browser" "zen-browser-bin"
    
    # Hyprland ecosystem
    install_yay "Fuzzel Launcher" "fuzzel"
    install_yay "EWW Widget Manager" "eww"
    install_yay "Hyprpaper" "hyprpaper"
    install_yay "SWWW Wallpaper Daemon" "swww"
    install_yay "Hyprshot Screenshot" "hyprshot"
    install_yay "AGS Hyprpanel" "ags-hyprpanel-git"
    
    # Development tools
    install_yay "JetBrains Toolbox" "jetbrains-toolbox"
    install_yay "NVM (Node Version Manager)" "nvm"
    
    # Utilities
    install_yay "Fastfetch" "fastfetch"
    install_yay "FZF Fuzzy Finder" "fzf"
    install_yay "FD Find Tool" "fd"
    install_yay "Yazi File Manager" "yazi"
    install_yay "Zellij Session Manager" "zellij"
    install_yay "Unzip" "unzip"
    install_yay "Keychain" "keychain"
    install_yay "Rsync" "rsync"
    
    # Media & Communication
    install_yay "Jellyfin client" "supersonic-desktop-wayland"
    install_yay "Discord" "discord"
    install_yay "Thunderbird Mail" "thunderbird"
    
    # Productivity
    install_yay "Blender" "blender"
    install_yay "Obsidian" "obsidian"
    install_yay "LibreOffice" "libreoffice"
    
    # System control
    install_yay "Bluetooth (Bluez)" "bluez bluez-utils"
    install_yay "Brightness Control" "brightnessctl"
    install_yay "Audio (Wireplumber)" "wireplumber"
    
    # Runtimes
    install_dotnet
    install_bun
}

# Sync configuration files
sync_config_files() {
    local source_config="$SCRIPT_DIR"
    local dest_config="$HOME/.config"
    
    if [[ ! -d "$source_config" ]]; then
        print_error "Config source directory '$source_config' not found"
        return 1
    fi
    
    print_info "Syncing configuration files to $dest_config..."
    
    # Create destination if it doesn't exist
    mkdir -p "$dest_config"
    
    # Sync each subfolder individually, excluding .git directories
    for config_dir in "$source_config"/*/; do
        if [[ -d "$config_dir" ]]; then
            local dir_name
            dir_name=$(basename "$config_dir")
            
            print_info "Syncing $dir_name..."
            rsync -av --delete \
                --exclude='.git' \
                --exclude='.gitignore' \
                --exclude='.gitmodules' \
                "${config_dir%/}" "$dest_config/"
        fi
    done
    
    print_info "Configuration sync completed"
}

# Setup directory structure and configurations
setup_configuration() {
    print_header "System Configuration"
    
    # Create user directories
    print_info "Creating directory structure..."
    mkdir -p "$HOME"/{Documents,Musics,Pictures,Programs,Videos}
    mkdir -p "$HOME/Projects"/{Softwares,Games}
    
    # Setup font directories
    print_info "Setting up font directories..."
    sudo mkdir -p /usr/local/share/fonts/{otf,ttf}
    
    # Install fonts if zip files exist
    if [[ -e "$SCRIPT_DIR/JetBrainsMono.zip" ]]; then
        print_info "Installing JetBrains Mono fonts..."
        sudo unzip -o "$SCRIPT_DIR/JetBrainsMono.zip" -d /usr/local/share/fonts/ttf/
        fc-cache -f
    else
        print_error "JetBrainsMono.zip not found in $SCRIPT_DIR"
    fi
    
    # Install SDDM theme if zip exists
    if [[ -e "$SCRIPT_DIR/catppuccin-mocha.zip" ]]; then
        print_info "Installing Catppuccin SDDM theme..."
        sudo mkdir -p /usr/share/sddm/themes/
        sudo unzip -o "$SCRIPT_DIR/catppuccin-mocha.zip" -d /usr/share/sddm/themes/ 
    fi
    sudo mkdir -p /etc/sddm.conf.d/
    sudo rsync "$SCRIPT_DIR/sddm.conf" /etc/sddm.conf.d/
    chsh -s /usr/bin/fish
}   

#------------------------------------------------------------------------------
# Main Execution
#------------------------------------------------------------------------------
main() {
    echo "Starting Arch setup – you must be a normal user!"
    print_info "Script directory: $SCRIPT_DIR"
    [[ $EUID -eq 0 ]] && { echo "Run as regular user, not root."; exit 1; }

    update_system
    install_packages
    sync_config_files 
    setup_configuration

    echo "All done! Reboot Now Buddy"
}

# Run main function
main "$@"
