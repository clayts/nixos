#!/bin/sh

cd $(readlink /etc/nixos) &&

# Update flake.lock
nix flake update &&

# If nothing changed,
if [ -z "$(git status --porcelain)" ]; then
    # We're finished here.
	echo "No update."
# Otherwise,
else
    # Commit these updates.
	git commit -m "update $(date)" -- ./flake.lock || exit 1
fi
