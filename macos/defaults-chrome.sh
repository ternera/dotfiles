#!/bin/bash

# Use the system-native print preview dialog
defaults write company.thebrowser.Browser DisablePrintPreview -bool true
defaults write com.google.Chrome DisablePrintPreview -bool true

# Expand the print dialog by default
defaults write company.thebrowser.Browser PMPrintingExpandedStateForPrint2 -bool true
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true

# Stop Chrome from saving login credentials and credit cards
defaults write company.thebrowser.Browser PasswordManagerEnabled -bool false
defaults write company.thebrowser.Browser AutofillCreditCardEnabled -bool false

# Install Chrome Extensions

# Define the Chrome Web Store URL base
BASE_URL="https://chrome.google.com/webstore/detail"

# Path to the Arc browser binary (adjust if needed)
ARC_BINARY="/Applications/Arc.app/Contents/MacOS/Arc"

if [ ! -f "$ARC_BINARY" ]; then
    echo "Arc Browser not found at $ARC_BINARY. Please check the installation path."
    exit 1
fi

# List of extension IDs to install
EXTENSIONS=(
    "ghmbeldphafepmbegfdlkpapadhbakde"  # Proton Pass
    "jplgfhpmjnbigmhklmmbgecoobifkmpa"  # Proton VPN
    "pnjaodmkngahhkoihejjehlcdlnohgmp"  # RSS Feed Reader
    "mnjggcdmjocbbbhaepdhchncahnbgone"  # SponsorBlock for YouTube
    "kdbmhfkmnlmbkgbabkdealhhbfhlmmon"  # SteamDB
    "cbghhgpcnddeihccjmnadmkaejncjndb"  # Vencord Web
    "cjpalhdlnbpafiamejdnhcphjbkeiagm"  # uBlock Origin

# Loop through the list and open each extension in Arc
for EXT_ID in "${EXTENSIONS[@]}"; do
    EXT_URL="${BASE_URL}/${EXT_ID}"
    echo "Opening $EXT_URL in Arc..."
    "$ARC_BINARY" "$EXT_URL"
done