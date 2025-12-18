#!/usr/bin/env bash

# Get the absolute path to the directory where this script is located.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Set the custom saver to our ultimate_lock_saver.sh script.
# The path must be absolute.
export XSECURELOCK_SAVER="$SCRIPT_DIR/xsecurelock-savers/ultimate_lock_saver.sh"

# Use the X11 auth module for the password prompt.
export XSECURELOCK_AUTH="/run/current-system/sw/bin/auth_x11"

# Show date, time, and keyboard layout.
export XSECURELOCK_SHOW_DATETIME="1"
export XSECURELOCK_DATETIME_FORMAT="%A, %d %B %Y %H:%M:%S"
export XSECURELOCK_SHOW_KEYBOARD_LAYOUT="1"
export XSECURELOCK_SHOW_CAPS_LOCK="1"

# We can customize the prompt colors if desired.
# export XSECURELOCK_PROMPT_COLOR="#ffffff"

xsecurelock
