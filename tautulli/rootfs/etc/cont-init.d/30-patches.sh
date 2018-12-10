#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: Tautulli
# Patches for Tautulli
# ==============================================================================

# Adds add-on support information in the settings of Tautulli
patch /opt/data/interfaces/default/configuration_table.html /patches/support
