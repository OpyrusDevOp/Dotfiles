Installation() {
  Installing_Message $1
  sudo pacman -S $2
}

Installation_Yay() {
  Installing_Message $1
  yay -S $2
}

Install_Dotnet() {
  Installing_Message Dotnet
  curl -L https://dot.net/v1/dotnet-install.sh -o dotnet-install.sh
  chmod +rx dotnet-install.sh
  ./dotnet-install.sh --version latest
}

Installing_Message() {
  echo "Installing $1 ..."
}

echo "####  App Installion  ####"

Installation "git" git

echo "Install Neovim Config ..."
git clone https://github.com/OpyrusDevOp/Neovim-Config.git ~/.config/nvim

echo "Installing Yay ..."
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

Installation "Terminal" kitty

Installation "Neovim" neovim

Installation "Shell" fish

Installation "Browser" firefox

Installation "AppLauncher" fuzzel

Installation "Widget Manager" eww

Installation "Dock" waybar

Installation "Wallpaper daemon" hyprpaper

Installation "Screenshot App" hyprshot

Installation "File Manager" yazi

Installation "Terminal Session Manager" zellij

Installation "Discord" discord

Installation "Obsidian" obsidian

Installation "Office suite" libreoffice

Installation "Unzip" unzip

Installation "Keychain" keychain

Installation "Bluetooth Control" "bluez bluez-utils"

Installation "Brightness Control" brightnessctl

Installation "Audio Control" libpulse

Install_Dotnet

Installing_Message Bun
curl -fsSL https://bun.sh/install | bash

Installation_Yay "Nvm" nvm

echo "#### Configuration ####"
mkdir -p ~/{Documents, Musics, Pictures, Projects/{Softwares, Games}, Videos}
mkdir -p /usr/local/share/fonts/{otf,ttf}
unzip ./JetBrainsMono.zip -d /usr/local/share/fonts/ttf/
