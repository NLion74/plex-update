#!/bin/bash

# Locations
Workingdir="$HOME"
Folder='plex-update'

# Check Versions
VersionInstalled=$(dpkg -s plexmediaserver | grep -Po '(?<=Version\: )(\S+)')
VersionAvailable=$(curl -s "https://plex.tv/downloads/details/1?build=linux-ubuntu-x86_64&channel=16&distro=ubuntu" | grep -Po '(?<=(\" version=\"))(\S+)(?=(\"))')
FileName=$(curl -s "https://plex.tv/downloads/details/1?build=linux-ubuntu-x86_64&channel=16&distro=ubuntu" | grep -Po '(?<=fileName=\")(\S+)(?=\")')
if [ "$VersionAvailable" = "$VersionInstalled" ]; then echo "Plex Media Server is already up-to-date (version $VersionInstalled)"; exit; fi

# Download package to designated location
curl -s "https://plex.tv/downloads/details/1?build=linux-ubuntu-x86_64&channel=16&distro=ubuntu" | grep -Po '(?<=url=\")(\S+)(?=\")' | xargs wget -P "${Workingdir}"/${Folder}

# Stop Plex Service
service plexmediaserver stop

# Install latest version
dpkg -i "${Workingdir}"/${Folder}/"$FileName"

# Start Plex Service
service plexmediaserver start

# Remove installation package from /tmp folder
rm "${Workingdir}"/${Folder}/plexmediaserver_*