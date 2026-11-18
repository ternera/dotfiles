#!/bin/bash
#set -x

ZEN_APP="/Applications/Zen.app"
DIST_DIR="$ZEN_APP/Contents/Resources/distribution"

if [ ! -d "$ZEN_APP" ]; then
    echo "Zen not found at $ZEN_APP, skipping browser policies."
    exit 0
fi

sudo mkdir -p "$DIST_DIR"
sudo tee "$DIST_DIR/policies.json" >/dev/null <<'JSON'
{
  "policies": {
    "DNSOverHTTPS": { "Enabled": true },
    "Preferences": {
      "network.trr.mode": { "Value": 3, "Status": "default" }
    },
    "PasswordManagerEnabled": false,
    "OfferToSaveLogins": false,
    "AutofillCreditCardEnabled": false,
    "ExtensionSettings": {
      "78272b6fa58f4a1abaac99321d503a20@proton.me": {
        "installation_mode": "normal_installed",
        "install_url": "https://addons.mozilla.org/firefox/downloads/latest/proton-pass/latest.xpi"
      },
      "vpn@proton.ch": {
        "installation_mode": "normal_installed",
        "install_url": "https://addons.mozilla.org/firefox/downloads/latest/proton-vpn-firefox-extension/latest.xpi"
      },
      "sponsorBlocker@ajay.app": {
        "installation_mode": "normal_installed",
        "install_url": "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi"
      },
      "firefox-extension@steamdb.info": {
        "installation_mode": "normal_installed",
        "install_url": "https://addons.mozilla.org/firefox/downloads/latest/steam-database/latest.xpi"
      },
      "firefox@tampermonkey.net": {
        "installation_mode": "normal_installed",
        "install_url": "https://addons.mozilla.org/firefox/downloads/latest/tampermonkey/latest.xpi"
      },
      "uBlock0@raymondhill.net": {
        "installation_mode": "normal_installed",
        "install_url": "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"
      }
    }
  }
}
JSON
