#!/usr/bin/env bash

echo 'Hi there!'
echo 'Greetings! This script will help you install this hyprland config.'
echo 'This script 1. only works for ArchLinux and Arch-based distros.'
echo '            2. is not tested, use at your own risk.'
echo '            3. will show all commands that it runs.'
echo '            4. should be run from its folder.'
echo '====BACKUP YOUR CONFIG FOLDER IF NEEDED!===='
echo 'All commands will be shown.'
echo 'Ctrl+C to exit. Enter to continue.'
read
#####################################################################################
user=$(whoami)

echo "Check graphics card you have"
lspci -k | grep -A 2 -E "(VGA|3D)"
echo " "
echo '1. Install Graphic Driver'
echo 'sudo pacman -S sudo pacman -S lib32-mesa xf86-video-amdgpu vulkan-radeon amdvlk lib32-vulkan-radeon libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau'
sudo pacman -S sudo pacman -S lib32-mesa xf86-video-amdgpu vulkan-radeon amdvlk lib32-vulkan-radeon libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau  
echo '(Make sure you say yes when asked to use sudo here)'
#####################################################################################

echo '2. Install some useful stuff'
sleep 1
echo 'sudo pacman -S vim network-manager-applet nm-connection-editor fcitx-unikey fcitx-im fcitx-ui-light kcm-fcitx fcitx-configtool fcitx-cloudpinyin nwg-look nodejs npm systemd-resolvconf spotify-launcher discord trash-cli mono mono-msbuild'
sudo pacman -S vim network-manager-applet nm-connection-editor fcitx-unikey fcitx-im fcitx-ui-light kcm-fcitx fcitx-configtool fcitx-cloudpinyin nwg-look nodejs npm systemd-resolvconf spotify-launcher discord trash-cli mono mono-msbuild
echo '(Make sure you say yes when asked to use sudo here)'
echo 'yay -S hyprshot neovim-git gitkraken linux-discord-rich-presence arrpc vscodium-bin vscodium-bin-marketplace vscodium-bin-features netcoredbg omnisharp-roslyn github-desktop-bin'
yay -S hyprshot neovim-git gitkraken linux-discord-rich-presence arrpc vscodium-bin vscodium-bin-marketplace vscodium-bin-features netcoredbg omnisharp-roslyn github-desktop-bin
#####################################################################################

echo '3. Get packages and add user to video/input groups'

echo 'yay -S blueberry brightnessctl coreutils curl fish foot fuzzel gjs gnome-bluetooth-3.0 gnome-control-center gnome-keyring gobject-introspection grim gtk3 gtk-layer-shell libdbusmenu-gtk3 meson networkmanager npm plasma-browser-integration playerctl polkit-gnome python-pywal ripgrep sassc slurp starship swayidle swaylock-effects-git typescript upower xorg-xrandr webp-pixbuf-loader wget wireplumber wl-clipboard tesseract yad ydotool adw-gtk3-git cava gojq gradience-git gtklock gtklock-playerctl-module gtklock-powerbar-module gtklock-userinfo-module hyprland-git lexend-fonts-git python-material-color-utilities python-pywal python-poetry python-build python-pillow swww ttf-material-symbols-variable-git ttf-space-mono-nerd ttf-jetbrains-mono-nerd wayland-idle-inhibitor-git wlogout'
yay -S blueberry brightnessctl coreutils curl fish foot fuzzel gjs gnome-bluetooth-3.0 gnome-control-center gnome-keyring gobject-introspection grim gtk3 gtk-layer-shell libdbusmenu-gtk3 meson networkmanager npm plasma-browser-integration playerctl polkit-gnome python-pywal ripgrep sassc slurp starship swayidle swaylock-effects-git typescript upower xorg-xrandr webp-pixbuf-loader wget wireplumber wl-clipboard tesseract yad ydotool adw-gtk3-git cava gojq gradience-git gtklock gtklock-playerctl-module gtklock-powerbar-module gtklock-userinfo-module hyprland-git lexend-fonts-git python-material-color-utilities python-pywal python-poetry python-build python-pillow swww ttf-material-symbols-variable-git ttf-space-mono-nerd ttf-jetbrains-mono-nerd wayland-idle-inhibitor-git wlogout

echo "sudo usermod -aG video $user"
sudo usermod -aG video "$user" || echo "failed to add user to video group"
echo "sudo usermod -aG input $user"
sudo usermod -aG input "$user" || echo "failed to add user to input group"
echo "Step 1 Complete."
#####################################################################################
echo '2. Installing AGS manually'
sleep 1
echo 'git clone --recursive https://github.com/Aylur/ags.git && cd ags'
git clone --recursive https://github.com/Aylur/ags.git && cd ags || echo "failed to clone into ags. Aborting..." && exit
echo "Done Cloning! Setting up npm and meson..."
sleep 1
echo 'npm install && meson setup build'
npm install && meson setup build
echo 'meson install -C build'
echo '(Make sure you say yes when asked to use sudo here)'
meson install -C build
#####################################################################################

echo '5. Copying'

echo 'cp -r "$HOME/Downloads/dotfiles/.config/" "$HOME"'
cp -r "$HOME/Downloads/dotfiles/.config/" "$HOME" || echo "cp threw error. You could cp this yourself."
echo 'cp -r $HOME/Downloads/dotfiles/.local" "$HOME"'
cp -r "$HOME/Downloads/dotfiles/.local" "$HOME" || echo "cp threw error. You could cp this yourself."
#####################################################################################

echo 'Enable Rich Precense (discord rpc)'

echo 'ln -sf $XDG_RUNTIME_DIR/{app/com.discordapp.Discord,}/discord-ipc-0 '
ln -sf $XDG_RUNTIME_DIR/{app/com.discordapp.Discord,}/discord-ipc-0 
echo 'mkdir -p ~/.config/user-tmpfiles.d'
mkdir -p ~/.config/user-tmpfiles.d
echo 'echo 'L %t/discord-ipc-0 - - - - app/com.discordapp.Discord/discord-ipc-0' > ~/.config/user-tmpfiles.d/discord-rpc.conf'
echo 'L %t/discord-ipc-0 - - - - app/com.discordapp.Discord/discord-ipc-0' > ~/.config/user-tmpfiles.d/discord-rpc.conf
echo 'systemctl --user enable --now systemd-tmpfiles-setup.service'
systemctl --user enable --now systemd-tmpfiles-setup.service
#####################################################################################
echo 'Install WhiteSur-GTK-Theme'

echo 'cd $HOME/Downloads/'
cd $HOME/Downloads/
echo 'git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git --depth=1 && cd WhiteSur-gtk-theme'
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git --depth=1 && cd WhiteSur-gtk-theme
echo 'sh ./install.sh -t all -N mojave'
sh ./install.sh -t all -N mojave
echo 'sh ./tweaks.sh -d -n -c Dark  -F -p 30 -i arch -f monterey'
sh ./tweaks.sh -d -n -c Dark  -F -p 30 -i arch -f monterey
echo 'Fix for Flatpak gtk-4.0 app:'
echo 'sudo flatpak override --filesystem=xdg-config/gtk-4.0' 
sudo flatpak override --filesystem=xdg-config/gtk-4.0
#####################################################################################

echo 'Install WhiteSur-Icon-Theme'

echo 'cd $HOME/Downloads/'
cd $HOME/Downloads/
echo 'git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git && cd WhiteSur-icon-theme'
git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git && cd WhiteSur-icon-theme
echo 'sh ./install.sh -b'
sh ./install.sh -b
#####################################################################################

echo 'Install WhiteSur-Kde-Theme'

echo 'Install Kvantum engine.'
echo 'cd $HOME'
cd $HOME
echo 'sudo pacman -S kvantum'
sudo pacman -S kvantum
echo '(Make sure you say yes when asked to use sudo here)'
echo 'cd $HOME/Downloads/'
cd $HOME/Downloads/
echo 'git clone https://github.com/vinceliuice/WhiteSur-kde.git && cd WhiteSur-kde'
git clone https://github.com/vinceliuice/WhiteSur-kde.git && cd WhiteSur-kde
echo 'sh ./install.sh --sharp'
sh ./install.sh --sharp
#####################################################################################

echo 'Finished :)'

