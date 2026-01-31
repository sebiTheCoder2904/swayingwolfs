#!/bin/bash
set -e

source /opt/gow/bash-lib/utils.sh

function launcher() {
  export XDG_DATA_DIRS=/usr/local/share/:/usr/share/

  if [ ! -d "$HOME/.config/sway" ]; then
    # set default config
    mkdir -p $HOME/.config/sway
    cp -r /opt/gow/sway/* $HOME/.config/sway

    
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
  export XDG_DATA_HOME="$HOME/.local/share"
  export _JAVA_AWT_WM_NONREPARENTING=1
  export GDK_BACKEND=wayland
  export MOZ_ENABLE_WAYLAND=1
  export QT_QPA_PLATFORM="xcb"
  export QT_AUTO_SCREEN_SCALE_FACTOR=1
  export QT_ENABLE_HIGHDPI_SCALING=1
  export DISPLAY=:0
  export $(dbus-launch)
  export REAL_WAYLAND_DISPLAY=$WAYLAND_DISPLAY


  unset WAYLAND_DISPLAY

  ARCH_CONTAINER="arch-wolf"

  mkdir -p "$XDG_DATA_HOME/containers/storage"

  
  if ! distrobox list | grep -q "$ARCH_CONTAINER"; then
    echo "Creating persistent Arch environment..."
    # --image: Use Arch Linux
    # --home: Ensure it uses the persistent home
    # --pull: Always get latest arch
    distrobox create --name "$ARCH_CONTAINER" \
                     --image archlinux:latest \
                     --home /home/retro \
                     --yes \
                     --absolutely-disable-root-password-i-am-really-positively-sure
  fi

  distrobox enter "$ARCH_CONTAINER" -- sudo pacman -Syu --noconfirm sway swaybg quickshell kitty 
  echo "Starting Arch environment..."
  # distrobox enter "$ARCH_CONTAINER" -- sway
  # distrobox enter "$ARCH_CONTAINER" -- bash -l -c 'sudo sway --unsupported-gpu'
  # Start Xwayland and swayfx
  # dbus-run-session -- bash -E -c 'distrobox enter arch-wolf -- sway'
  dbus-run-session -- bash -E -c 'sway'


  
}
