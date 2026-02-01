#!/bin/bash
set -e
source /opt/gow/bash-lib/utils.sh

function launcher() {
    export GAMESCOPE_WIDTH=${GAMESCOPE_WIDTH:-1920}
    export GAMESCOPE_HEIGHT=${GAMESCOPE_HEIGHT:-1080}
    export GAMESCOPE_REFRESH=${GAMESCOPE_REFRESH:-60}

    GAMESCOPE_MODE=${GAMESCOPE_MODE:-"-b"}
    echo "output * resolution ${GAMESCOPE_WIDTH}x${GAMESCOPE_HEIGHT} position 0,0" >> $HOME/.config/sway/config

    /usr/games/gamescope "${GAMESCOPE_MODE}" -W "${GAMESCOPE_WIDTH}" -H "${GAMESCOPE_HEIGHT}" -r "${GAMESCOPE_REFRESH}" -- /usr/local/bin/distrobox enter arch-wolf -- bash -l -c "export XDG_RUNTIME_DIR=/run/host/run/user/wolf/ && export PULSE_SERVER=unix:/run/host/run/user/wolf/pulse-socket && export PULSE_COOKIE=/run/host/home/retro/.config/pulse/cookie && exec sway"

}
