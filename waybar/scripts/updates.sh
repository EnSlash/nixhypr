#!/bin/sh

# A more robust update script for Nix profiles managed by 'nix profile'.

# Update channels silently
nix-channel --update > /dev/null 2>&1

# Run the upgrade check, capturing stdout and stderr
updates=$(nix profile upgrade '.*' --dry-run 2>&1)
exit_code=$?

# First, check if the command itself ran successfully.
# A non-zero exit code is an error, unless the error message is "nothing to upgrade".
if [ $exit_code -ne 0 ] && ! echo "$updates" | grep -q 'nothing to upgrade'; then
    # There was a real error running the command.
    echo "{\"text\": \"ERR\", \"tooltip\": \"Error checking for updates. Check script manually.\"}"
    exit 1
fi

# If the command ran, check for the '->' symbol which indicates an upgrade.
# The -e flag tells grep that the next argument is the pattern.
if echo "$updates" | grep -q -e '->'; then
    count=$(echo "$updates" | grep -c -e '->')
    echo "{\"text\": \"$count \", \"tooltip\": \"Updates available. Run 'nix profile upgrade .*' to upgrade.\"}"
else
    # If there's no '->', it means no packages are being upgraded.
    echo "{\"text\": \"\", \"tooltip\": \"System is up to date.\"}"
fi
