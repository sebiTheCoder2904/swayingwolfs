FROM gameonwhales/base-app:edge

ARG DEBIAN_FRONTEND=noninteractive

ARG CORE_PACKAGES=" \
    lsb-release \
    wget \
    gnupg2 \
    dbus-x11 \
    sudo \
    "

ARG ADDITIONAL_PACKAGES=" \
    zip unzip p7zip-full \
    podman \
    fuse-overlayfs \
    curl \
    uidmap \
    "

RUN \
    # \    
    apt-get update && \
    # \
    # Install core packages \
    apt-get install -y $CORE_PACKAGES && \
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


# Install Distrobox (latest version)
RUN curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sh

# Replace launch scripts
# COPY --chmod=777 scripts/launch-comp.sh scripts/startup.sh /opt/gow/
# COPY --chmod=777 scripts/startdbus.sh /opt/gow/startdbus
COPY --chmod=777 scripts/startup.sh /opt/gow/startup-app.sh

# Include default sway config
COPY --chmod=777 --chown=retro:retro scripts/sway /opt/gow/sway
COPY --chmod=777 --chown=retro:retro scripts/distrobox-sway-wrapper.sh /opt/gow/distrobox-sway-wrapper.sh

# Fix locals
COPY scripts/locale /etc/default/locale


# 
# Allow anyone to start dbus without password
RUN echo "\nALL ALL=NOPASSWD: /opt/gow/startdbus" >> /etc/sudoers
RUN echo "\nretro ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# RUN groupadd -f fuse && usermod -aG fuse retro

ARG IMAGE_SOURCE
LABEL org.opencontainers.image.source=$IMAGE_SOURCE
