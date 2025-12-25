#!/bin/sh
# NixOS-specific script to perform a system update.
# This will be run in a terminal window.

echo "Starting NixOS system upgrade..."
sudo nixos-rebuild switch --upgrade

# Keep the terminal open to see the result
echo "Update process finished. Press Enter to close this window."
read
