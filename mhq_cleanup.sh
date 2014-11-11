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
DAEMON_NAME="com.macqh.mhq_cleanup.plist"

#########################
#
# delete the agents & daemons
#
#########################

rm "/Library/LaunchAgents/${AGENT_NAME}"

launchctl unload "/Library/LaunchDaemons/${DAEMON_NAME}"
rm "/Library/LaunchDaemons/${DAEMON_NAME}"

#########################
#
# delete this script
#
#########################

rm "${0}"
