#!/bin/sh

cd $(dirname "$0") &&

# Update flake.lock
nix flake update &&

# If nothing changed,
if [ -z "$(git status --porcelain ./flake.lock)" ]; then
    # We're finished here.
	echo "No update." && exit 1
else
    # Commit these updates.
	git commit ./flake.lock -m "Update $(date)"
fi
