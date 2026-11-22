#!/usr/bin/env bash
# macOS preferences via `defaults write`. Only settings changed from the macOS
# defaults on the main machine are listed here. Safe to re-run (idempotent).
# Run it by hand; install.sh doesn't call it. Some settings need a logout to apply.
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "macos.sh: not macOS, skipping" >&2
    exit 0
fi

if (( $# > 0 )); then
    echo "usage: $0  (takes no options)" >&2
    exit 1
fi

# If System Settings is open, it can overwrite the values written below.
osascript -e 'tell application "System Settings" to quit' 2> /dev/null || true

# --- Appearance ---------------------------------------------------------------
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# --- Keyboard -----------------------------------------------------------------
# Fastest repeat / shortest delay that System Settings offers.
defaults write NSGlobalDomain KeyRepeat -float 2
defaults write NSGlobalDomain InitialKeyRepeat -float 15
# Holding a key repeats it instead of showing the accent picker (vim hjkl).
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# --- Text input ---------------------------------------------------------------
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticInlinePredictionEnabled -bool false

# --- Pointer ------------------------------------------------------------------
# No pointer acceleration for mice.
defaults write NSGlobalDomain com.apple.mouse.linear -bool true
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 0.875
# Tap to click: built-in and Bluetooth trackpads, plus the login screen.
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# --- Menu bar -----------------------------------------------------------------
# Always auto-hide (0 = always, 1 = on desktop only, 2 = in full screen only, 3 = never).
defaults write NSGlobalDomain _HIHideMenuBar -bool true
defaults write com.apple.controlcenter AutoHideMenuBarOption -int 0
# Always show the date (0 = when space allows, 1 = always, 2 = never).
defaults write com.apple.menuextra.clock ShowDate -int 1

# --- Dock ---------------------------------------------------------------------
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -float 61

# --- Finder -------------------------------------------------------------------
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# New windows open in the home folder (PfHm) instead of Recents.
defaults write com.apple.finder NewWindowTarget -string "PfHm"
# Delete items that have been in the Trash for more than 30 days.
defaults write com.apple.finder FXRemoveOldTrashItems -bool true

# --- Windows ------------------------------------------------------------------
# No gaps between tiled windows.
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false

# --- Apply --------------------------------------------------------------------
for app in Dock Finder SystemUIServer ControlCenter; do
    killall "$app" > /dev/null 2>&1 || true
done

echo "Done. Log out and back in for keyboard and trackpad changes to take effect."
