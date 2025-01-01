#!/bin/sh

# Constants
DOTFILES_DIR="$HOME/.dotfiles"
DOTFILES_GIT="git --git-dir=$DOTFILES_DIR --work-tree=$HOME"

# Helper function to check if dotfiles repo is initialized
check_repo() {
    if [ ! -d "$DOTFILES_DIR" ]; then
        echo "Dotfiles repository not initialized. Run 'dotfiles init <git-repo-url>' first."
        exit 1
    fi
}

# Initialize the dotfiles repository
init() {
    if [ -z "$1" ]; then
        echo "Error: Git repository URL required"
        echo "Usage: dotfiles init <git-repo-url>"
        exit 1
    fi

    if [ -d "$DOTFILES_DIR" ]; then
        echo "Dotfiles repository already initialized"
        exit 1
    fi

    # Create bare git repo
    git clone --bare "$1" "$DOTFILES_DIR"

    # Configure repository
    $DOTFILES_GIT config status.showUntrackedFiles no

    # Get list of all files in the repository
    cd "$HOME" || exit 1
    REPO_FILES=$($DOTFILES_GIT ls-tree --full-tree -r HEAD | awk '{print $4}')

    # Check which files would conflict
    CONFLICTS=""
    for file in $REPO_FILES; do
        if [ -e "$HOME/$file" ]; then
            CONFLICTS="$CONFLICTS$file"$'\n'
        fi
    done

    if [ -n "$CONFLICTS" ]; then
        echo "The following files would be overwritten:"
        echo "$CONFLICTS"
        echo -n "Continue? [y/N] "
        read -r response
        if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
            echo "$CONFLICTS" | while read -r file; do
                [ -n "$file" ] && rm "$HOME/$file"
            done
            $DOTFILES_GIT checkout
        else
            echo "Aborting..."
            rm -rf "$DOTFILES_DIR"  # Clean up the failed init
            exit 1
        fi
    else
        $DOTFILES_GIT checkout
    fi

    echo "Dotfiles repository initialized successfully"
}

# Track new files
track() {
    check_repo

    if [ $# -eq 0 ]; then
        echo "Error: File path(s) required"
        echo "Usage: dotfiles track <file-path> [<file-path> ...]"
        exit 1
    fi

    for file in "$@"; do
        # Convert to absolute path if necessary
        FILE_PATH=$(realpath "$file")

        if [ ! -e "$FILE_PATH" ]; then
            echo "Error: File does not exist: $FILE_PATH"
            continue
        fi

        $DOTFILES_GIT add "$FILE_PATH"
        echo "Now tracking: $FILE_PATH"
    done
}

# Untrack files
untrack() {
    check_repo

    if [ $# -eq 0 ]; then
        echo "Error: File path(s) required"
        echo "Usage: dotfiles untrack <file-path> [<file-path> ...]"
        exit 1
    fi

    for file in "$@"; do
        FILE_PATH=$(realpath "$file")
        $DOTFILES_GIT rm --cached "$FILE_PATH"
        echo "Stopped tracking: $FILE_PATH"
    done
}

# List tracked files
list() {
    check_repo
    cd "$HOME" && $DOTFILES_GIT ls-files
}

# Show status of dotfiles
status() {
    check_repo
    $DOTFILES_GIT status
}

# Push changes to remote
push() {
    check_repo

    # Only add changes to already-tracked files
    $DOTFILES_GIT add -u

    # Only commit and push if there are changes
    if ! $DOTFILES_GIT diff --cached --quiet; then
        timestamp=$(date "+%Y-%m-%d %H:%M:%S")
        $DOTFILES_GIT commit -m "$timestamp"
        $DOTFILES_GIT push
        echo "Changes pushed to remote repository"
    else
        echo "No changes to push"
    fi
}

# Pull changes from remote
pull() {
    check_repo
    $DOTFILES_GIT pull
    echo "Changes pulled from remote repository"
}

# Main command handler
case "$1" in
    "init")
        init "$2"
        ;;
    "track")
        shift  # Remove 'track' from arguments
        track "$@"  # Pass all remaining arguments
        ;;
    "untrack")
        shift  # Remove 'untrack' from arguments
        untrack "$@"  # Pass all remaining arguments
        ;;
    "list")
        list
        ;;
    "status")
        status
        ;;
    "log")
        log
        ;;
    "push")
        push
        ;;
    "pull")
        pull
        ;;
    *)
        echo "Usage:"
        echo "  dotfiles init <git-repo-url>"
        echo "  dotfiles track <file-path> [<file-path> ...]"
        echo "  dotfiles untrack <file-path> [<file-path> ...]"
        echo "  dotfiles list"
        echo "  dotfiles status"
        echo "  dotfiles log"
        echo "  dotfiles pull"
        echo "  dotfiles push"
        exit 1
        ;;
esac
