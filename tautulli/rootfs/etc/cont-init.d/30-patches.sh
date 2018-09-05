#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: Tautulli
# Patches for Tautulli
# ==============================================================================

# Adds buymeacoffe link
patch /opt/data/interfaces/default/base.html /patches/buymeacoffe

# Adds add-on support information in the settings of Tautulli
patch /opt/data/interfaces/default/configuration_table.html /patches/support