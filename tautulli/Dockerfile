ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:9.5.0
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

ENV \
  PIP_BREAK_SYSTEM_PACKAGES=1 \
  TAUTULLI_VERSION="v2.18.1"

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Sets working directory
WORKDIR /opt

# Copy Python requirements file
COPY requirements.txt /tmp/

# Setup base
RUN \
  apt-get update \
  && apt-get install -y --no-install-recommends \
    git=1:2.47.3-0+deb13u1 \
    python3-pip=25.1.1+dfsg-1 \
    python3=3.13.5-1 \
  \
  && pip install \
    --no-cache-dir \
    --prefer-binary \
    -r /tmp/requirements.txt \
  \
  && git clone --branch "${TAUTULLI_VERSION}" --depth=1 \
    https://github.com/Tautulli/Tautulli.git /opt \
  \
  && find /usr/local \( \
      \( -type d -a \( -name test -o -name tests -o -name '__pycache__' \) \) \
      -o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
    \) -exec rm -rf '{}' + \
  \
  && apt-get purge -y --auto-remove \
    git \
    python3-pip \
  \
  && rm -fr \
    /opt/{.git,.github,init-scripts} \
    /tmp/* \
    /var/{cache,log}/* \
    /var/lib/apt/lists/*

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
    maintainer="Franck Nijhof <opensource@frenck.dev>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Community Apps" \
    org.opencontainers.image.authors="Franck Nijhof <opensource@frenck.dev>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://frenck.dev/home-assistant-apps" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
