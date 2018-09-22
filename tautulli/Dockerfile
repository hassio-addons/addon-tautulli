ARG BUILD_FROM=hassioaddons/base:2.2.0
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set env
ENV TAUTULLI_VERSION 'v2.1.21'

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Sets working directory
WORKDIR /opt

# Setup base
RUN \
  apk add --no-cache --virtual .build-dependencies \
    g++=6.4.0-r8 \
    gcc=6.4.0-r8 \
    make=4.2.1-r2 \
    python2-dev=2.7.15-r1 \
    libffi-dev=3.2.1-r4 \
    libressl-dev=2.7.4-r0 \
  \
  && apk add --no-cache \
    git=2.18.0-r0 \
    python2=2.7.15-r1 \
    py2-pip=10.0.1-r0 \
    wget=1.19.5-r0 \
  \
  && pip install --no-cache-dir -U \
    pip==18.0 \
  && pip install --no-cache-dir -U \
    plexapi==3.0.6 \
    pycryptodomex==3.6.6 \
    crudini==0.9 \
    PyOpenSSL==18.0.0 \
  \
  && git clone --branch $TAUTULLI_VERSION --depth=1 \
    https://github.com/Tautulli/Tautulli.git /opt \
  && apk del --purge .build-dependencies \
  \
  && find /usr/lib/python2.7/ -type d -name tests -depth -exec rm -rf {} \; \
  && find /usr/lib/python2.7/ -type d -name test -depth -exec rm -rf {} \; \
  && find /usr/lib/python2.7/ -name __pycache__ -depth -exec rm -rf {} \;

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
    org.label-schema.url="https://community.home-assistant.io/t/community-hass-io-add-on-tautulli/68745?u=ludeeus" \
    org.label-schema.usage="https://github.com/hassio-addons/addon-tautulli/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/hassio-addons/addon-tautulli" \
    org.label-schema.vendor="Community Hass.io Add-ons"
