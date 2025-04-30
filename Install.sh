echo "Installing git ..."
sudo pacman -S git

echo "Install Neovim Config ..."
git clone https://github.com/OpyrusDevOp/Neovim-Config.git ~/.config/nvim

echo "Installing Yay ..."
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

echo "Install Terminal ..."
sudo pacman -S kitty

echo "Install Shell ..."
sudo pacman -S fish

echo "Install Browser ..."
sudo pacman -S firefox

echo "Install AppLauncher ..."
sudo pacman -S fuzzel

echo "Install Dock ..."
sudo pacman -S waybar

echo "Install Wallpaper daemon ..."
sudo pacman -S hyprpaper

echo "Install File Manager ..."
sudo pacman -S nautilus

echo "Install Terminal Session Manager ..."
sudo pacman -S zellij

echo "Install Discord ..."
sudo pacman -S discord

echo "Install Obsidian ..."
sudo pacman -S obsidian

echo "Install Bun ..."
curl -fsSL https://bun.sh/install | bash
