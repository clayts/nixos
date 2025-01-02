#!/bin/sh
nh clean all -k 3 && nix-store --optimise
