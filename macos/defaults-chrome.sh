#!/bin/bash

# Use the system-native print preview dialog
defaults write com.google.Chrome DisablePrintPreview -bool true
defaults write com.google.Chrome.canary DisablePrintPreview -bool true

# Expand the print dialog by default
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true
defaults write com.google.Chrome.canary PMPrintingExpandedStateForPrint2 -bool true

# Stop Chrome from saving login credentials and credit cards
defaults write com.google.Chrome.plist PasswordManagerEnabled -bool false
defaults write com.google.Chrome.plist AutofillCreditCardEnabled -bool false

