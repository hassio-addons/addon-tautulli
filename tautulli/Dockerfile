ARG BUILD_FROM=hassioaddons/base:2.1.2
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Sets working directory
WORKDIR /app

# Setup base
RUN \
  apk add --no-cache --virtual=build-dependencies \
  apache2-utils=2.4.34-r0 \
  autoconf=2.69-r2 \
  automake=1.16.1-r0 \
  g++=6.4.0-r8 \
  gcc=6.4.0-r8 \
  linux-headers=4.4.6-r2 \
  make=4.2.1-r2 \
  python2-dev=2.7.15-r1 \
  tar=1.30-r0 && \
  apk add --no-cache \
  coreutils=8.29-r2 \
  git=2.18.0-r0 \
  py2-lxml=4.2.2-r0 \
  py2-pip=10.0.1-r0 \
  python2=2.7.15-r1 \
  shadow=4.5-r0 \
  nginx=1.14.0-r0 \
  vnstat=1.18-r0 \
  wget=1.19.5-r0 && \
  pip install --no-cache-dir -U \
  pip==18.0 && \
  pip install --no-cache-dir -U \
  plexapi==3.0.6 \
  pycryptodomex==3.6.6 && \
  groupmod -g 1000 users && \
  useradd -u 911 -U -d /config -s /bin/false tautulli && \
  usermod -G users tautulli && \
  mkdir -p \
  /app \
  /defaults \
    && git clone --branch v2.1.18 --depth=1 \
        https://github.com/Tautulli/Tautulli.git /app
  
# TODO Move up
ENV LANG en_US.utf8

# Copy root filesystem
COPY rootfs /

# Build arugments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="Tautulli" \
    io.hass.description="Monitoring and tracking tool for Plex Media Server." \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Joakim Sørensen @ludeeus <ludeeus@gmail.com>" \
    org.label-schema.description="Monitoring and tracking tool for Plex Media Server." \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Tautulli" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://addons.community" \
    org.label-schema.usage="https://github.com/hassio-addons/addon-tautulli/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/hassio-addons/addon-tautulli" \
    org.label-schema.vendor="Community Hass.io Add-ons"
