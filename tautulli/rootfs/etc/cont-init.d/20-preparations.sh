#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: Tautulli
# Preparing configuration for Tautulli
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

CONFIG=/data/config.ini
ADDON=/data/addon.ini

# If config.ini does not exist, create it.
if ! hass.file_exists "/data/config.ini"; then
    hass.log.info "Creating default configuration..."
    crudini --set "$CONFIG" General first_run_complete 0
    crudini --set "$CONFIG" General update_show_changelog 0
    crudini --set "$CONFIG" Advanced system_analytics 0
    crudini --set "$ADDON" Addon version "$TAUTULLI_VERSION"
fi

hass.log.info "Updating running configuration..."

# Temporrary changing config.ini to be valid during additions
## This has to be done because Tautulli added a ini header with [[header]]
sed -i "s/\\[\\[get_file_sizes_hold\\]\\]/\\[get_file_sizes_hold\\]/" "$CONFIG"

# Set spesific config if an upgrade
CURRENT_VERSION=$(crudini --get "$ADDON" Addon version)
if [ "$CURRENT_VERSION" != "$TAUTULLI_VERSION" ]; then
    hass.log.debug "This is an upgrade..."
    crudini --set "$CONFIG" General update_show_changelog 1
else
    hass.log.debug "This is not an upgrade..."
    crudini --set "$CONFIG" General update_show_changelog 0
fi

# Ensure config
crudini --set "$ADDON" Addon version "$TAUTULLI_VERSION"
crudini --set "$CONFIG" General check_github 0
crudini --set "$CONFIG" General check_github_on_startup 0

# Update SSL info in configuration
if hass.config.true 'ssl'; then
    hass.log.info "Ensure SSL is active in the configuration..."
    crudini --set "$CONFIG" General enable_https 1
    crudini --set "$CONFIG" General https_cert_chain "\"/ssl/$(hass.config.get 'certfile')\""
    crudini --set "$CONFIG" General https_cert "\"/ssl/$(hass.config.get 'certfile')\""
    crudini --set "$CONFIG" General https_key "\"/ssl/$(hass.config.get 'keyfile')\""
else
    hass.log.info "Ensure SSL is not active in the configuration..."
    crudini --set "$CONFIG" General enable_https 0
    crudini --set "$CONFIG" General https_cert_chain "\"\""
    crudini --set "$CONFIG" General https_cert "\"\""
    crudini --set "$CONFIG" General https_key "\"\""
fi

# Update username and password in configuration
if hass.config.has_value 'username' && hass.config.has_value 'password'; then
    hass.log.info "Ensure authentication is enabled in the configuration..."
    crudini --set "$CONFIG" General http_username "\"$(hass.config.get 'username')\""
    crudini --set "$CONFIG" General http_password "\"$(hass.config.get 'password')\""
else
    hass.log.info "Ensure authentication is not enabled in the configuration..."
    crudini --set "$CONFIG" General http_username "\"\""
    crudini --set "$CONFIG" General http_password "\"\""
fi

# Changing config.ini back.
## This has to be done because Tautulli added a ini header with [[header]]
sed -i "s/\\[get_file_sizes_hold\\]/\\[\\[get_file_sizes_hold\\]\\]/" "$CONFIG"