#!/bin/sh

nh clean all -k 10 &&
nix-store --optimise || exit 1
