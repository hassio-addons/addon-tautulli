ARG BUILD_FROM=hassioaddons/base:7.1.1
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set env
ENV TAUTULLI_VERSION 'v2.2.1'

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Sets working directory
WORKDIR /opt

# Copy Python requirements file
COPY requirements.txt /tmp/

# Setup base
RUN \
  apk add --no-cache --virtual .build-dependencies \
    g++=9.2.0-r4 \
    gcc=9.2.0-r4 \
    libffi-dev=3.2.1-r6 \
    libressl-dev=3.0.2-r0 \
    make=4.2.1-r2 \
    python2-dev=2.7.16-r3 \
  \
  && apk add --no-cache \
    git=2.24.3-r0 \
    libressl=3.0.2-r0 \
    py2-pip=18.1-r0 \
    python2=2.7.16-r3 \
    wget=1.20.3-r0 \
  \
  && pip install --no-cache-dir -U -r /tmp/requirements.txt \
  \
  && git clone --branch $TAUTULLI_VERSION --depth=1 \
    https://github.com/Tautulli/Tautulli.git /opt \
  && apk del --no-cache --purge .build-dependencies \
  \
  && rm -f -r /tmp/* \
  && find /usr/lib/python2.7/ -type d -name tests -depth -exec rm -rf {} \; \
  && find /usr/lib/python2.7/ -type d -name test -depth -exec rm -rf {} \; \
  && find /usr/lib/python2.7/ -name __pycache__ -depth -exec rm -rf {} \;

# Copy root filesystem
COPY rootfs /

# Build arguments
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
    org.label-schema.url="https://community.home-assistant.io/t/home-assistant-community-add-on-tautulli/68745?u=ludeeus" \
    org.label-schema.usage="https://github.com/hassio-addons/addon-tautulli/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/hassio-addons/addon-tautulli" \
    org.label-schema.vendor="Home Assistant Community Add-ons"
