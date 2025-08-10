#!/bin/bash

CONFIG_DIR="$HOME/.config/convert"
SCRIPT_DIR="$HOME/.local/bin"

mkdir -p "$CONFIG_DIR"
mkdir -p "$SCRIPT_DIR"

cp tool/units.config "$CONFIG_DIR/units.config"
cp tool/convert.sh "$SCRIPT_DIR/convert.sh"

chmod +r "$SCRIPT_DIR/convert.sh"

if [ -n "$ZSH_VERSION" ]; then
    PROFILE="$HOME/.zshrc"
    PROFILE_LOGIN="$HOME/.zprofile"
else
    PROFILE="$HOME/.bashrc"
    PROFILE_LOGIN="$HOME/.bash_profile"
fi

if ! grep -q "source $SCRIPT_DIR/convert.sh" "$PROFILE"; then
    echo "source $SCRIPT_DIR/convert.sh" >> "$PROFILE"
    echo "- Added source to $PROFILE"
else
    echo "- Source line already exists in $PROFILE"
fi
if ! grep -q "source $SCRIPT_DIR/convert.sh" "$PROFILE_LOGIN"; then
    echo "source $SCRIPT_DIR/convert.sh" >> "$PROFILE_LOGIN"
    echo "- Added source to $PROFILE_LOGIN"
else
    echo "- Source line already exists in $PROFILE_LOGIN"
fi

source "$PROFILE"

echo "- Installation complete!"
echo "- Restart your terminal or run: source $PROFILE"
echo "- Try: convert -s 1.5GB KB"