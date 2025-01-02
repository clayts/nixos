#!/bin/sh

cd $(readlink /etc/nixos) &&

# If git is clean,
if [ -z "$(git status --porcelain)" ]; then
	# Update flake.lock
	nix flake update &&

    # If nothing changed,
	if [ -z "$(git status --porcelain)" ]; then
        # We're finished here.
		echo "No update."
	# Otherwise,
    else
        # Commit these updates.
		git commit -am "update $(date)" || exit 1
	fi
# Otherwise,
else
	# Refuse.
    echo "Update cancelled: Working tree is not clean."
    exit 1
fi
