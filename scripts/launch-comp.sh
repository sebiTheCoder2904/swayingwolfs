#!/bin/bash
set -e

source /opt/gow/bash-lib/utils.sh

function launcher() {
  export XDG_DATA_DIRS=/var/lib/flatpak/exports/share:/home/retro/.local/share/flatpak/exports/share:/usr/local/share/:/usr/share/

  if [ ! -d "$HOME/.config/sway" ]; then
    # set default config
    mkdir -p $HOME/.config/sway
    cp -r /opt/gow/sway/* $HOME/.config/sway

    # add flathub repo
    flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    
    
    # Create commun folders
    mkdir ~/Desktop ~/Documents ~/Downloads ~/Music ~/Pictures ~/Public ~/Templates ~/Videos
    chmod 755 ~/Desktop ~/Documents ~/Downloads ~/Music ~/Pictures ~/Public ~/Templates ~/Videos
  fi

  #
  # Launch DBUS
  sudo /opt/gow/startdbus

  export DESKTOP_SESSION=sway
  export XDG_CURRENT_DESKTOP=sway
  export XDG_SESSION_TYPE="wayland"
  export _JAVA_AWT_WM_NONREPARENTING=1
  export GDK_BACKEND=wayland
  export MOZ_ENABLE_WAYLAND=1
  export QT_QPA_PLATFORM="xcb"
  export QT_AUTO_SCREEN_SCALE_FACTOR=1
  export QT_ENABLE_HIGHDPI_SCALING=1
  export DISPLAY=:0
  export $(dbus-launch)
  export REAL_WAYLAND_DISPLAY=$WAYLAND_DISPLAY
  export TERM=xterm
  export PATH="$PATH:/home/retro/.junest/usr/bin_wrappers"
  export PATH="$PATH:/home/retro/.local/share/junest/bin"


  /home/retro/.local/share/junest/bin/sudoj /home/retro/.junest/usr/bin_wrappers/pacman -S swayfx
  #
  # Start Xwayland and swayfx
  dbus-run-session -- bash -E -c swayfx
}
