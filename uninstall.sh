#!/bin/bash

CONFIG_DIR="$HOME/.config/convert"
SCRIPT_DIR="$HOME/.local/bin"

clean_profile() {
    [ ! -f "$1" ] && return
    local tmp=$(mktemp)
    grep -v "source $SCRIPT_DIR/convert.sh" "$1" > "$tmp"
    mv "$tmp" "$1"
}

if [ -n "$ZSH_VERSION" ]; then
    PROFILE="$HOME/.zshrc"
    PROFILE_LOGIN="$HOME/.zprofile"
else
    PROFILE="$HOME/.bashrc"
    PROFILE_LOGIN="$HOME/.bash_profile"
fi

rm -f "$SCRIPT_DIR/convert.sh"
rm -rf "$CONFIG_DIR"

clean_profile "$PROFILE"
clean_profile "$PROFILE_LOGIN"

echo "- Uninstallation complete!"
echo "- Restart your terminal"