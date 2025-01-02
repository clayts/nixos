#!/bin/sh
nh os switch $(readlink /etc/nixos) && sudo fc-cache -r
