FROM gameonwhales/base-app:edge

ARG CORE_PACKAGES=" \
    lsb-release \
    wget \
    gnupg2 \
    dbus-x11 \
    sudo \
    git \
    flatpak \
    "

ARG DE_PACKAGES=" \
    sway \
    "

ARG ADDITIONAL_PACKAGES=" \
    zip unzip p7zip-full \
    gnome-software gnome-software-plugin-flatpak \
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

RUN chown root:root /usr/bin/bwrap
RUN chmod a+x /usr/bin/bwrap

ENV XDG_RUNTIME_DIR=/tmp/.X11-unix

ARG IMAGE_SOURCE
LABEL org.opencontainers.image.source=$IMAGE_SOURCE


# junest

RUN git clone https://github.com/fsquillace/junest.git /home/retro/.local/share/junest 

ENV PATH="$PATH:/home/retro/.junest/usr/bin_wrappers"
ENV PATH="$PATH:/home/retro/.local/share/junest/bin"

RUN  junest setup
