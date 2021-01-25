ARG BUILD_FROM=ghcr.io/hassio-addons/base/amd64:9.1.1
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set env
ENV TAUTULLI_VERSION 'v2.6.5'

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
    g++=10.2.1_pre1-r3 \
    gcc=10.2.1_pre1-r3 \
    libffi-dev=3.3-r2 \
    libressl-dev=3.1.5-r0 \
    make=4.3-r0 \
    python3-dev=3.8.7-r0 \
  \
  && apk add --no-cache \
    git=2.30.0-r0 \
    libressl=3.1.5-r0 \
    patch=2.7.6-r6 \
    py3-pip=20.3.4-r0 \
    python3=3.8.7-r0 \
    wget=1.21.1-r1 \
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
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Joakim Sørensen @ludeeus <ludeeus@gmail.com>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Joakim Sørensen @ludeeus <ludeeus@gmail.com>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
