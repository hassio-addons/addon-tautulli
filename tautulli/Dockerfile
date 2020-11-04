ARG BUILD_FROM=hassioaddons/base:8.0.5
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set env
ENV TAUTULLI_VERSION 'v2.6.1'

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Sets working directory
WORKDIR /opt

# Copy Python requirements file
COPY requirements.txt /tmp/

# Setup base
ARG BUILD_ARCH=amd64
RUN \
  apk add --no-cache --virtual .build-dependencies \
    g++=9.3.0-r2 \
    gcc=9.3.0-r2 \
    libffi-dev=3.3-r2 \
    libressl-dev=3.1.2-r0 \
    make=4.3-r0 \
    python3-dev=3.8.5-r0 \
  \
  && apk add --no-cache \
    git=2.26.2-r0 \
    libressl=3.1.2-r0 \
    py3-pip=20.1.1-r0 \
    python3=3.8.5-r0 \
    wget=1.20.3-r1 \
  \
  && pip install \
      --no-cache-dir \
      --prefer-binary \
      --find-links "https://wheels.home-assistant.io/alpine-3.12/${BUILD_ARCH}/" \
      -r /tmp/requirements.txt \
  \
  && git clone --branch "${TAUTULLI_VERSION}" --depth=1 \
    https://github.com/Tautulli/Tautulli.git /opt \
  \
  && find /usr/local \
      \( -type d -a -name test -o -name tests -o -name '__pycache__' \) \
      -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
      -exec rm -rf '{}' + \
  \
  && apk del --no-cache --purge .build-dependencies \
  && rm -f -r /tmp/*

# Copy root filesystem
COPY rootfs /

# Build arguments
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="Tautulli" \
    io.hass.description="Monitoring and tracking tool for Plex Media Server" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Joakim Sørensen @ludeeus <ludeeus@gmail.com>" \
    org.opencontainers.image.title="Tautulli" \
    org.opencontainers.image.description="Monitoring and tracking tool for Plex Media Server" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Joakim Sørensen @ludeeus <ludeeus@gmail.com>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/hassio-addons/addon-tautulli" \
    org.opencontainers.image.documentation="https://github.com/hassio-addons/addon-tautulli/blob/master/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
