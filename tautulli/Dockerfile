ARG BUILD_FROM=ghcr.io/hassio-addons/base/amd64:12.0.0
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set env
ENV TAUTULLI_VERSION 'v2.8.1'

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
    g++=11.2.1_git20220219-r2 \
    gcc=11.2.1_git20220219-r2 \
    libffi-dev=3.4.2-r1 \
    openssl-dev=1.1.1o-r0 \
    make=4.3-r0 \
    python3-dev=3.10.4-r \
  \
  && apk add --no-cache \
    git=2.36.1-r0 \
    openssl=1.1.1o-r0 \
    patch=2.7.6-r7 \
    py3-cryptography=3.4.8-r1 \
    py3-pip=22.1.1-r0 \
    python3=3.10.4-r \
    wget=1.21.3-r0 \
  \
  && pip install \
      --no-cache-dir \
      --prefer-binary \
      --find-links "https://wheels.home-assistant.io/alpine-3.16/${BUILD_ARCH}/" \
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
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
