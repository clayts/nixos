#!/bin/sh

# Change directory to where this script is located
cd $(dirname "$0") &&

# Switch
nh os switch .

# Update font cache
sudo fc-cache -r
