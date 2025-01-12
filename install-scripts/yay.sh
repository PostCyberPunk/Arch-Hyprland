#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# Yay AUR Helper #
# NOTE: If paru is already installed, yay will not be installed #


## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_yay.log"

# Check for AUR helper and install if not found
ISAUR=$(command -v yay || command -v paru)

if [ -n "$ISAUR" ]; then
  printf "\n%s - AUR helper already installed, moving on.\n" "${OK}"
else
  printf "\n%s - AUR helper was NOT located\n" "$WARN"
  printf "\n%s - Installing yay from AUR\n" "${NOTE}"
  git clone https://aur.archlinux.org/yay-bin.git || { printf "%s - Failed to clone yay from AUR\n" "${ERROR}"; exit 1; }
  cd yay-bin || { printf "%s - Failed to enter yay-bin directory\n" "${ERROR}"; exit 1; }
  makepkg -si --noconfirm 2>&1 | tee -a "$LOG" || { printf "%s - Failed to install yay from AUR\n" "${ERROR}"; exit 1; }
fi

# Update system before proceeding
printf "\n%s - Performing a full system update to avoid issues.... \n" "${NOTE}"
ISAUR=$(command -v yay || command -v paru)

$ISAUR -Syu --noconfirm 2>&1 | tee -a "$LOG" || { printf "%s - Failed to update system\n" "${ERROR}"; exit 1; }

clear