#!/bin/bash

# Update package list
apt-get update

# Install necessary dependencies
apt-get install -y x11-xserver-utils xdotool xautomation x11-apps

# Create necessary directories
mkdir -p /usr/share/icons/default/

# Create or update index.theme file
cat > /usr/share/icons/default/index.theme << EOL
[Icon Theme]
Name=Default
Comment=Default Cursor Theme
Inherits=DMZ-White
EOL

# Install the DMZ-White cursor theme
apt-get install -y dmz-cursor-theme

# Set the cursor theme
update-alternatives --set x-cursor-theme /usr/share/icons/DMZ-White/cursor.theme

# Clean up
apt-get clean
rm -rf /var/lib/apt/lists/*