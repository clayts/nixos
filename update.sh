#!/bin/sh

# Change directory to where this script is located
cd $(dirname "$0") &&

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
		git commit -am "Update $(date)" || exit 1
	fi
# Otherwise,
else
	# Refuse.
    echo "Update cancelled: Working tree is not clean."
    exit 1
fi
