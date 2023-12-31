#!/usr/bin/env bash
cd "$(dirname "$0")"
export base="$(pwd)"
user=$(whoami) 

function try { "$@" || sleep 0; }
function v() {
  echo -e "[$0]: \e[34mNow executing:\e[0m"
  echo -e "\e[32m$@\e[0m"
  execute=true
  if $ask;then
    while true;do
      echo -e "\e[34mDo you want to execute this command? \e[0m"
      echo "  y = Yes"
      echo "  a = Abort this script"
      echo "  s = Skip this command; NOT recommended unless you really sure"
      echo "  yesforall = yes and don't ask again; NOT recommended unless you really sure"
      read -p "Enter here [y/a/s/yesforall]:" p
      case $p in
        [yY]) echo -e "\e[34mOK, executing...\e[0m" ;break ;;
        [aA]) echo -e "\e[34mAborting...\e[0m" ;exit ;break ;;
        [sS]) echo -e "\e[34mAlright, skipping this one...\e[0m" ;export execute=false ;break ;;
        "yesforall") echo -e "\e[34mAlright, won't ask again. Executing...\e[0m"; export ask=false ;break ;;
        *) echo -e "\e[31mPlease enter one of [y/a/s/yesforall].\e[0m";;
      esac
    done
  fi
  if $execute;then
  "$@"
  fi
}
#####################################################################################
printf "[$0]: Hi there!\n"
printf 'This script 1. only works for ArchLinux and Arch-based distros.\n'
printf '            2. has not been fully tested, use at your own risk.\n'
printf "\e[36m== PLEASE BACKUP \"$HOME/.config\" AND \"$HOME/.local\" BY YOURSELF IF NEEDED! ==\n\e[97m"
printf '\n'
printf 'Do you want to confirm everytime before a command executes?\n'
printf '      y = Yes, ask me before executing each of them. (RECOMMENDED)\n'
printf '      n = No, just execute them automatically.\n'
printf '      E = Exit this script. (DEFAULT)\n'
read -p "Enter y/n/E: " p
case $p in
  y)export ask=true;;
  n)export ask=false; export c=" --noconfirm" ;;
  *)exit;;
esac
set -e
#####################################################################################

printf '\e[36m1. Check graphics card you have \n\e[97m'
v lspci -k | grep -A 2 -E "(VGA|3D)"
printf '\e[36m1. 1. Install Graphic Driver \n\e[97m'
v sudo pacman -S lib32-mesa xf86-video-amdgpu vulkan-radeon amdvlk lib32-vulkan-radeon libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau  
#####################################################################################

printf '\e[36m1. 2. Install some useful stuff\n\e[97m'
sleep 1
v sudo pacman -S vim network-manager-applet nm-connection-editor fcitx-unikey fcitx-im fcitx-ui-light kcm-fcitx fcitx-configtool fcitx-cloudpinyin nodejs npm systemd-resolvconf spotify-launcher discord trash-cli mono mono-msbuild hyprshot
v yay -S --needed --noconfirm neovim-git gitkraken linux-discord-rich-presence arrpc vscodium-bin vscodium-bin-marketplace vscodium-bin-features netcoredbg omnisharp-roslyn github-desktop-bin nwg-look vencord-desktop 
#####################################################################################

printf '\e[36m1. Get packages and add user to video/input groups\n\e[97m'
v yay -S blueberry brightnessctl coreutils curl fish foot fuzzel gjs gnome-bluetooth-3.0 gnome-control-center gnome-keyring gobject-introspection grim gtk3 gtk-layer-shell libdbusmenu-gtk3 meson networkmanager npm plasma-browser-integration playerctl polkit-gnome python-pywal ripgrep sassc slurp starship swayidle swaylock-effects-git typescript upower xorg-xrandr webp-pixbuf-loader wget wireplumber wl-clipboard tesseract yad ydotool adw-gtk3-git cava gojq gradience-git gtklock gtklock-playerctl-module gtklock-powerbar-module gtklock-userinfo-module hyprland-git lexend-fonts-git python-material-color-utilities python-pywal python-poetry python-build python-pillow swww ttf-material-symbols-variable-git ttf-space-mono-nerd ttf-jetbrains-mono-nerd wayland-idle-inhibitor-git wlogout wlsunset-git 
printf '\e[36m1. 4. Enable Rich Precense (discord rpc) \n\e[97m'
v ln -sf $XDG_RUNTIME_DIR/{app/com.discordapp.Discord,}/discord-ipc-0 
v mkdir -p ~/.config/user-tmpfiles.d
v echo 'echo 'L %t/discord-ipc-0 - - - - app/com.discordapp.Discord/discord-ipc-0' > ~/.config/user-tmpfiles.d/discord-rpc.conf'
v echo 'L %t/discord-ipc-0 - - - - app/com.discordapp.Discord/discord-ipc-0' > ~/.config/user-tmpfiles.d/discord-rpc.conf
v echo 'systemctl --user enable --now systemd-tmpfiles-setup.service'
v systemctl --user enable --now systemd-tmpfiles-setup.service
#####################################################################################

sleep 1
v sudo usermod -aG video "$user"
v sudo usermod -aG input "$user"
#####################################################################################
printf '\e[36m2. Installing AGS from git repo\e[97m\n'
sleep 1

installags (){
  v git clone --recursive https://github.com/Aylur/ags.git|| \
    if [ -d ags ];then
      printf "\e[36mSeems \"./ags\" already exists.\e[97m\n"
      cd ags
      v git pull
    else exit 1
    fi
  v npm install
  v meson setup build 
  v meson install -C build
  cd $base
}
if command -v ags >/dev/null 2>&1
  then echo -e "\e[34mCommand \"ags\" already exists. Won't install ags.\e[0m"
  else installags
fi

#####################################################################################

printf '\e[36m3. Copying\e[97m\n'

# In case ~/.local/bin does not exists
v mkdir -p "$HOME/.local/bin"

# `--delete' for rsync to make sure that
# original dot files and new ones in the SAME DIRECTORY
# (eg. in ~/.config/hypr) won't be mixed together

for i in .config/*
do
  echo "Found target: $i"
  if [ -d "$i" ];then v rsync -av --delete "$i/" "$HOME/$i/"
  elif [ -f "$i" ];then v rsync -av "$i" "$HOME/$i"
  fi
done

# .local/bin should be processed seperately to avoid `--delete' for rsync,
# since the files here comes from different places, not only one program.
v rsync -av ".local/bin/" "$HOME/.local/bin/"

#####################################################################################

printf '\e[36m1. 7. Install WhiteSur-GTK-Theme \n\e[97m'
v cd $HOME/Downloads/
v git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git --depth=1 && cd WhiteSur-gtk-theme
v sh ./install.sh -t all -N mojave
v sh ./tweaks.sh -d -n -c Dark -p 30 -i arch -f monterey
v cd $HOME/Downloads/
v rm -rf WhiteSur-gtk-theme
#####################################################################################

printf '\e[36m1. 8. Install WhiteSur-Icon-Theme \n\e[97m'
v cd $HOME/Downloads/
v git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git && cd WhiteSur-icon-theme
v sh ./install.sh -b
v cd $HOME/Downloads/
v rm -rf WhiteSur-icon-theme
#####################################################################################

printf '\e[36m1. 9. Install WhiteSur-Kde-Theme \n\e[97m'
vcd $HOME
v sudo pacman -S kvantum
v cd $HOME/Downloads/
v git clone https://github.com/vinceliuice/WhiteSur-kde.git && cd WhiteSur-kde
v sh ./install.sh --sharp
v cd $HOME/Downloads/
v rm -rf WhiteSur-kde
#####################################################################################

sleep 1
printf "[$0]: \e[36mFinished. See the \"Import Manually\" folder and grab anything you need.\e[97m\n"
printf "\e[36mPress \e[30m\e[46m Ctrl+Super+T \e[0m\e[36m to select a wallpaper\e[97m\n"
printf "\e[36mPress \e[30m\e[46m Super+/ \e[0m\e[36m for a list of keybinds\e[97m\n"

