#!/bin/bash

# Paths to the theme files
THEME_FILE="$HOME/dotfiles/ghostty/.config/ghostty/theme"
THEME_LIGHT="$HOME/dotfiles/ghostty/.config/ghostty/theme_light"
THEME_DARK="$HOME/dotfiles/ghostty/.config/ghostty/theme_dark"

# Check if the contents of the theme file match theme_dark
if cmp -s "$THEME_FILE" "$THEME_DARK"; then
  # Replace with theme_light
  cp "$THEME_LIGHT" "$THEME_FILE"
else
  # Replace with theme_dark
  cp "$THEME_DARK" "$THEME_FILE"
fi

# Run the reload_config.scpt script
osascript "$HOME/dotfiles/ghostty/.config/ghostty/reload_config.scpt"

