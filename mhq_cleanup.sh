#!/bin/sh

########################################################
#
# mhq_cleanup.sh
#
# The goal of this script is to run after the setup script 
# has run and delete itself and any Launch Agents & Daemon 
# plist files.
# 
# This script is expected to be run as a LaunchDaemon to 
# allow it root priviledges so that it can delete files. 
#
# Current idea is to have the setup script delete itself, 
# and this to check for its presence. Once the setup script 
# is gone, run this script to do any cleanup.
#
# Cleanup includes:
# - Delete the LaunchAgent that launched the "setup" file
# - Delete the LaunchDaemon that launched this file
# - Delete this file
#
########################################################

#########################
#
# set hardcoded values
#
#########################

AGENT_NAME="com.machq.mhq_setup.plist"
DAEMON_NAME="com.machq.mhq_cleanup.plist"

#########################
#
# delete the agents & daemons
#
#########################

#launchctl stop "${AGENT_NAME}"
#launchctl unload "/Library/LaunchAgents/${AGENT_NAME}"
#launchctl remove "${AGENT_NAME}"

/usr/bin/srm -mf "/Library/LaunchAgents/${AGENT_NAME}" 2>/dev/null

#launchctl stop "${DAEMON_NAME}"
#launchctl unload "/Library/LaunchDaemons/${DAEMON_NAME}"
#launchctl remove "${DAEMON_NAME}"

/usr/bin/srm -mf "/Library/LaunchDaemons/${DAEMON_NAME}" 2>/dev/null

#########################
#
# delete this script
#
#########################

rm "${0}"
