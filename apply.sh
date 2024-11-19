#!/bin/sh

# Change directory to where this script is located
cd $(dirname "$0") &&

# Switch, clean, and optimise
nh os switch . &&
nh clean all -k 3 &&
nix-store --optimise || exit 1
