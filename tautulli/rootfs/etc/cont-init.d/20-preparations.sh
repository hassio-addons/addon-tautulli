#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: Tautulli
# Preparing configuration for Tautulli
# ==============================================================================

readonly ADDON=/data/addon.ini
readonly CONFIG=/data/config.ini
readonly DATABASE=/share/tautulli/tautulli.db
readonly SHARE=/share/tautulli

# If config.ini does not exist, create it.
if ! bashio::fs.file_exists "$CONFIG"; then
    bashio::log.info "Creating default configuration..."
    crudini --set "$CONFIG" General first_run_complete 0
    crudini --set "$CONFIG" General update_show_changelog 0
    crudini --set "$CONFIG" Advanced system_analytics 0
    crudini --set "$ADDON" Addon version "$TAUTULLI_VERSION"
fi

bashio::log.info "Updating running configuration..."

# Temporrary changing config.ini to be valid during additions
## This has to be done because Tautulli added a ini header with [[header]]
sed -i "s/\\[\\[get_file_sizes_hold\\]\\]/\\[get_file_sizes_hold\\]/" "$CONFIG"

# Set spesific config if an upgrade
if ! bashio::fs.file_exists "/data/addon.ini"; then
    crudini --set "$ADDON" Addon version "0"
fi
CURRENT_VERSION=$(crudini --get "$ADDON" Addon version)
if [ "$CURRENT_VERSION" != "$TAUTULLI_VERSION" ]; then
    bashio::log.debug "This is an upgrade..."
    crudini --set "$CONFIG" General update_show_changelog 1
else
    bashio::log.debug "This is not an upgrade..."
    crudini --set "$CONFIG" General update_show_changelog 0
fi

# Ensure config
crudini --set "$ADDON" Addon version "$TAUTULLI_VERSION"
crudini --set "$CONFIG" General check_github 0
crudini --set "$CONFIG" General check_github_on_startup 0

# Update SSL info in configuration
if bashio::config.true 'ssl'; then
    bashio::log.info "Ensure SSL is active in the configuration..."
    crudini --set "$CONFIG" General enable_https 1
    crudini --set "$CONFIG" General https_cert_chain "\"/ssl/$(bashio::config 'certfile')\""
    crudini --set "$CONFIG" General https_cert "\"/ssl/$(bashio::config 'certfile')\""
    crudini --set "$CONFIG" General https_key "\"/ssl/$(bashio::config 'keyfile')\""
else
    bashio::log.info "Ensure SSL is not active in the configuration..."
    crudini --set "$CONFIG" General enable_https 0
    crudini --set "$CONFIG" General https_cert_chain "\"\""
    crudini --set "$CONFIG" General https_cert "\"\""
    crudini --set "$CONFIG" General https_key "\"\""
fi

# Update username and password in configuration
if bashio::config.has_value 'username' && bashio::config.has_value 'password'; then
    bashio::log.info "Ensure authentication is enabled in the configuration..."
    crudini --set "$CONFIG" General http_username "\"$(bashio::config 'username')\""
    crudini --set "$CONFIG" General http_password "\"$(bashio::config 'password')\""
else
    bashio::log.info "Ensure authentication is not enabled in the configuration..."
    crudini --set "$CONFIG" General http_username "\"\""
    crudini --set "$CONFIG" General http_password "\"\""
fi

# Changing config.ini back.
## This has to be done because Tautulli added a ini header with [[header]]
sed -i "s/\\[get_file_sizes_hold\\]/\\[\\[get_file_sizes_hold\\]\\]/" "$CONFIG"

# Create /share/tautulli if it does not exist.
if ! bashio::fs.directory_exists "$SHARE"; then
    mkdir "$SHARE"
fi

# Use databasefile from /share/tautulli if it exist.
if bashio::fs.file_exists "$DATABASE"; then
    bashio::log.info "Using database from $DATABASE"
    ln -sf "$DATABASE" /data/tautulli.db
fi
