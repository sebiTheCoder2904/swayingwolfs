FROM gameonwhales/base-app:edge

ARG CORE_PACKAGES=" \
    lsb-release \
    wget \
    gnupg2 \
    dbus-x11 \
    flatpak \
    sudo \
    git \
    "

ARG DE_PACKAGES=" \
    sway \
    at-spi2-core \
    waybar \
    wofi \
    bemenu \
    swaybg \
    swaylock \
    swayidle \
    grim \
    slurp \
    wl-clipboard \
    cliphist \
    "

ARG ADDITIONAL_PACKAGES=" \
    zip unzip p7zip-full \
    "



RUN \
    # \    
    apt-get update && \
    # \
    # Install core packages \
    apt-get install -y $CORE_PACKAGES && \
    # \
    # Install de \
    apt-get install -y $DE_PACKAGES && \
    # \
    # Install additional apps \
    apt-get install -y --no-install-recommends $ADDITIONAL_PACKAGES && \
    # \
    

    # Clean \
    apt update && \
    apt-get remove -y foot && \
    apt autoremove -y &&\
    apt clean && \
    rm -rf \
        /config/.cache \
        /var/lib/apt/lists/* \
        /var/tmp/* \
        /tmp/*


RUN apt-get update && apt-get install -y bubblewrap
RUN chmod u+s $(which bwrap)


# Replace launch scripts
COPY --chmod=777 scripts/launch-comp.sh scripts/startup.sh /opt/gow/
COPY --chmod=777 scripts/startdbus.sh /opt/gow/startdbus

# Include default sway config
COPY --chmod=777 --chown=retro:retro scripts/sway /opt/gow/sway

# Fix locals
COPY scripts/locale /etc/default/locale

# 
# Allow anyone to start dbus without password
RUN echo "\nALL ALL=NOPASSWD: /opt/gow/startdbus" >> /etc/sudoers
