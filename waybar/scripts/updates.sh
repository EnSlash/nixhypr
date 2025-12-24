#!/bin/sh

# This is a simple update script for Nix.
# It doesn't calculate the exact number of packages, but shows if updates are available.

# First, update the channels to get the latest package information
nix-channel --update > /dev/null 2>&1

# Check for available updates for the user profile
updates=$(nix-env -u --dry-run)

if [ -n "$updates" ]; then
    # If the 'updates' variable is not empty, there are updates
    count=$(echo "$updates" | grep -c 'upgrading')
    if [ "$count" -gt 0 ]; then
        echo "{\"text\": \"$count \", \"tooltip\": \"Updates available. Run nix-env -u to upgrade.\"}"
    else
        echo "{\"text\": \"\", \"tooltip\": \"System is up to date.\"}"
    fi
else
    # If 'updates' is empty, no updates are available.
    echo "{\"text\": \"\", \"tooltip\": \"System is up to date.\"}"
fi
