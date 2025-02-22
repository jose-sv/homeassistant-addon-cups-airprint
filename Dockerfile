FROM ghcr.io/hassio-addons/debian-base:7.6.2

LABEL io.hass.version="1.5" io.hass.type="addon" io.hass.arch="aarch64|amd64"

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        sudo \
        locales \
        cups \
        avahi-daemon \
        libnss-mdns \
        dbus \
        colord \
        printer-driver-all \
        printer-driver-gutenprint \
        openprinting-ppds \
        cups-pdf \
        gnupg2 \
        lsb-release \
        nano \
        samba \
        bash-completion \
        procps \
        whois \
        libcupsimage2 \
        cups-bsd \
        libgtk-3-0 \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

COPY rootfs /

# Add user and disable sudo password checking
RUN useradd \
  --groups=sudo,lp,lpadmin \
  --create-home \
  --home-dir=/home/print \
  --shell=/bin/bash \
  --password=$(mkpasswd print) \
  print \
&& sed -i '/%sudo[[:space:]]/ s/ALL[[:space:]]*$/NOPASSWD:ALL/' /etc/sudoers

RUN dpkg -i /drivers/linux-UFRII-drv-v600-us/ARM64/Debian/cnrdrvcups-ufr2-us_6.00-1.02_arm64.deb

# RUN chmod +x /drivers/linux-UFRII-drv-v600-us/install.sh \
# && /drivers/linux-UFRII-drv-v600-us/install.sh

EXPOSE 631

RUN chmod a+x /run.sh

CMD ["/run.sh"]
