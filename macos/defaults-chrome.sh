#!/bin/bash
#set -x

# Enable secure DNS
defaults write company.thebrowser.Browser DnsOverHttpsMode -string "secure"

# Use the system-native print preview dialog
defaults write company.thebrowser.Browser DisablePrintPreview -bool true
defaults write com.google.Chrome DisablePrintPreview -bool true

# Expand the print dialog by default
defaults write company.thebrowser.Browser PMPrintingExpandedStateForPrint2 -bool true
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true

# Stop Chrome from saving login credentials and credit cards
defaults write company.thebrowser.Browser PasswordManagerEnabled -bool false
defaults write company.thebrowser.Browser AutofillCreditCardEnabled -bool false

# Keep Google safe search enabled all the time
defaults write company.thebrowser.Browser GoogleSafeSearch -int 1
defaults write company.thebrowser.Browser ForceBingSafeSearch -int 2


: '
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
    "nmkinhboiljjkhaknpaeaicmdjhagpep"  # Fluff Busting Purity

# Loop through the list and open each extension in Arc
for EXT_ID in "${EXTENSIONS[@]}"; do
    EXT_URL="${BASE_URL}/${EXT_ID}"
    echo "Opening $EXT_URL in Arc..."
    "$ARC_BINARY" "$EXT_URL"
done


declare -A EXTlist=(
    ["google-translate"]="aapbdbdomjkkjkaonfhkkikfgjllcleb"
    ["save-to-google-drive"]="gmbmikajjgmnabiglmofipeabaddhgne"
)
for i in "${!EXTlist[@]}"; do
    # echo "Key: $i value: ${EXTlist[$i]}"
    echo '{"external_update_url": "https://clients2.google.com/service/update2/crx"}' > /opt/google/chrome/extensions/${EXTlist[$i]}.json
done
'