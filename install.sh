#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

printf 'Hi there!\n'
printf 'This script 1. only works for ArchLinux and Arch-based distros.\n'
printf '            2. has not been tested, use at your own risk.\n'
printf '            3. will show all commands that it runs.\n'
printf "\e[36m== BACKUP YOUR CONFIG FOLDER IF NEEDED! ==\n"
printf 'Ctrl+C to exit. Enter to continue.\n'
read -r
#####################################################################################
user=$(whoami) 

printf '\e[36m1. Check graphics card you have \n\e[97m'
set -v
lspci -k | grep -A 2 -E "(VGA|3D)"
set +v
printf '\e[36m1. 1. Install Graphic Driver \n\e[97m'
set -v
sudo pacman -S lib32-mesa xf86-video-amdgpu vulkan-radeon amdvlk lib32-vulkan-radeon libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau  
set +v
#####################################################################################

printf '\e[36m1. 2. Install some useful stuff\n\e[97m'
sleep 1
sudo pacman -S vim network-manager-applet nm-connection-editor fcitx-unikey fcitx-im fcitx-ui-light kcm-fcitx fcitx-configtool fcitx-cloudpinyin nodejs npm systemd-resolvconf spotify-launcher discord trash-cli mono mono-msbuild hyprshot
yay -S --needed --noconfirm neovim-git gitkraken linux-discord-rich-presence arrpc vscodium-bin vscodium-bin-marketplace vscodium-bin-features netcoredbg omnisharp-roslyn github-desktop-bin nwg-look vencord-desktop
set +v
#####################################################################################

printf '\e[36m1. Get packages and add user to video/input groups\n\e[97m'
set -v
yay -S blueberry brightnessctl coreutils curl fish foot fuzzel gjs gnome-bluetooth-3.0 gnome-control-center gnome-keyring gobject-introspection grim gtk3 gtk-layer-shell libdbusmenu-gtk3 meson networkmanager npm plasma-browser-integration playerctl polkit-gnome python-pywal ripgrep sassc slurp starship swayidle swaylock-effects-git typescript upower xorg-xrandr webp-pixbuf-loader wget wireplumber wl-clipboard tesseract yad ydotool adw-gtk3-git cava gojq gradience-git gtklock gtklock-playerctl-module gtklock-powerbar-module gtklock-userinfo-module hyprland-git lexend-fonts-git python-material-color-utilities python-pywal python-poetry python-build python-pillow swww ttf-material-symbols-variable-git ttf-space-mono-nerd ttf-jetbrains-mono-nerd wayland-idle-inhibitor-git wlogout wlsunset-git
set +v
printf '\e[36m1. 4. Enable Rich Precense (discord rpc) \n\e[97m'
set -v
ln -sf $XDG_RUNTIME_DIR/{app/com.discordapp.Discord,}/discord-ipc-0 
mkdir -p ~/.config/user-tmpfiles.d
echo 'echo 'L %t/discord-ipc-0 - - - - app/com.discordapp.Discord/discord-ipc-0' > ~/.config/user-tmpfiles.d/discord-rpc.conf'
echo 'L %t/discord-ipc-0 - - - - app/com.discordapp.Discord/discord-ipc-0' > ~/.config/user-tmpfiles.d/discord-rpc.conf
echo 'systemctl --user enable --now systemd-tmpfiles-setup.service'
systemctl --user enable --now systemd-tmpfiles-setup.service
set +v
#####################################################################################

sleep 1
set -v
sudo usermod -aG video "$user"
sudo usermod -aG input "$user"
set +v
#####################################################################################
printf '\e[36m1. A \n\e[97m'
printf '\e[36m1. 5. Installing AGS manually \n\e[97m'
sleep 1
set -v
git clone --recursive https://github.com/Aylur/ags.git && cd ags
set +v
sleep 1
set -v
npm install && meson setup build
meson install -C build
set +v
#####################################################################################

printf '\e[36m1. 6. Copying \n\e[97m'
set -v
cp -r "$HOME/dotfiles/.config/" "$HOME"
cp -r "$HOME/dotfiles/.local" "$HOME"
set +v
#####################################################################################

printf '\e[36m1. 7. Install WhiteSur-GTK-Theme \n\e[97m'
set -v
cd $HOME/Downloads/
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git --depth=1 && cd WhiteSur-gtk-theme
sh ./install.sh -t all -N mojave
sh ./tweaks.sh -d -n -c Dark -p 30 -i arch -f monterey
cd $HOME/Downloads/
rm -rf WhiteSur-gtk-theme
set +v
#####################################################################################

printf '\e[36m1. 8. Install WhiteSur-Icon-Theme \n\e[97m'
set -v
cd $HOME/Downloads/
git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git && cd WhiteSur-icon-theme
sh ./install.sh -b
cd $HOME/Downloads/
rm -rf WhiteSur-icon-theme
set +v
#####################################################################################

printf '\e[36m1. 9. Install WhiteSur-Kde-Theme \n\e[97m'
set -v
cd $HOME
sudo pacman -S kvantum
cd $HOME/Downloads/
git clone https://github.com/vinceliuice/WhiteSur-kde.git && cd WhiteSur-kde
sh ./install.sh --sharp
cd $HOME/Downloads/
rm -rf WhiteSur-kde
set +v
#####################################################################################

sleep 1
printf 'Finished. See the "Import manually" folder and grab anything you need.\e[97m\n'
printf 'Press Ctrl+Super+T to select a wallpaper\e[97m\n'
printf 'Press Super+/ for a list of keybinds\e[97m\n'

