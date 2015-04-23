#!/bin/sh

########################################################
#
# mhq_setup.sh
#
# The goal of this script is to run upon first login to the
# initial user account and set default settings & install 
# the MHQ Tools app to the desktop.
# 
# This script is expected to be run as a LaunchAgent to 
# delay running until the user account has logged in and the 
# home folder created, as some of the defaults & the tools 
# app require the home folder structure to be present.
#
# Current steps are:
# - Set energy saver settings to never sleep, never sleep, and 
# never spin down the hard drive.
# - Set default homepage to "http://twitter.com/#!/MacHQ/"
# - Show HD on desktop "Finder Prefs" & rename w/Size
# - Move the MHQ Tools app from "/Users/shared/" to the 
# desktop of the default account
#
########################################################

#########################
#
# set hardcoded values
#
#########################

ACCOUNT_NAME="me"
SCREEN_SAVER_NAME="Random"
SCREEN_SAVER_PATH="/System/Library/Screen Savers/Random.saver"
HOME_PAGE="http://twitter.com/machq"
TOOL_APP_LOCATION="/Users/shared/"
TOOL_APP_NAME="MacHQ Tools 5.app"

#########################
#
# verify user account
#
#########################

CURRENT_USER=`whoami`

if [ ${CURRENT_USER} != ${ACCOUNT_NAME} ]; then
    echo "Not logged into correct user account; quitting."
    exit 1
fi

#########################
#
# set screensaver
#
#########################

# disabled until I can figure out how to get the nested expansion to work :(
#defaults -currentHost write com.apple.screensaver moduleDict '{ moduleName = ${SCREEN_SAVER_NAME}; path = "${SCREEN_SAVER_PATH}"; type = 8; }'

defaults -currentHost write com.apple.screensaver moduleDict '{ moduleName = Random; path = "/System/Library/Screen Savers/Random.saver"; type = 8; }'

#########################
#
# set homepage
#
#########################

touch "/Users/${ACCOUNT_NAME}/Library/Preferences/com.apple.Safari.plist"

defaults write com.apple.Safari HomePage "${HOME_PAGE}"
defaults write com.apple.Safari NewWindowBehavior 0

#########################
#
# set energy saver settings
#
#########################

# this need sudo to run, at least during testing. hopefully run as a LaunchAgent it won't be necessary. also "systemsetup" may be useful but also requires sudo

sudo pmset -c displaysleep 0 sleep 0 disksleep 0

#########################
#
# set hd name & visibility
#
#########################

boot_vol=`bless --getBoot`
boot_disk=`diskutil info ${boot_vol} |sed '/^ *Volume Name: */!d;s###'`
disk_size=`system_profiler SPSerialATADataType |sed '/^ *Capacity: */!d;s###' | awk '{print int($1+0.5)  $2" HD"}' | head -n 1 `
diskutil rename "${boot_disk}" "${disk_size}"
# Show icons for hard drives, servers, and removable media on the desktop
#defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
#defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
#defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
killall Finder

#########################
#
# move MHQ Tools app
#
#########################

if [ -e "${TOOL_APP_LOCATION}${TOOL_APP_NAME}" ]; then
	mv "${TOOL_APP_LOCATION}${TOOL_APP_NAME}" "/Users/${ACCOUNT_NAME}/Desktop/"
fi

#########################
#
# remove this script
#
#########################

rm "${0}"
