#! /bin/bash

run_task() {
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            --name) name="$2"; shift ;;
            --check-cmd) check_cmd="$2"; shift ;;
            --run-cmd) run_cmd="$2"; shift ;;
        esac
        shift
    done

    echo "📝 Task: $name"
    if ! eval "$check_cmd" > /dev/null 2>&1; then
        if eval "$run_cmd"; then
            echo "  ✅ Setup completed successfully!"
        else
            echo "  ❌ Error during '$name'. Please check the permissions and templates." >&2
            exit 1
        fi
    else
        echo "  ✅ Already set up."
    fi
}

bool_to_number() {
    [ "$1" = "true" ] && echo 1 || echo 0
}

run_task \
    --name "Request Touch ID instead of password for sudo" \
    --check-cmd "grep -q '^auth' /etc/pam.d/sudo_local" \
    --run-cmd "sed -e 's/^#auth/auth/' /etc/pam.d/sudo_local.template | sudo tee /etc/pam.d/sudo_local"

DOCK_ICON_SIZE=55
run_task \
    --name "Set dock icons size" \
    --check-cmd "defaults read com.apple.dock tilesize | grep -q \"$DOCK_ICON_SIZE\"" \
    --run-cmd "defaults write com.apple.dock tilesize -int $DOCK_ICON_SIZE && killall Dock"

DOCK_AUTOHIDE=true
run_task \
    --name "Set dock autohide" \
    --check-cmd "defaults read com.apple.dock autohide | grep -q \"$(bool_to_number "$DOCK_AUTOHIDE")\"" \
    --run-cmd "defaults write com.apple.dock autohide -bool $DOCK_AUTOHIDE && killall Dock"

DOCK_AUTOHIDE_DURATION=0.5
run_task \
    --name "Set dock autohide duration" \
    --check-cmd "defaults read com.apple.dock autohide-time-modifier | grep -q \"$DOCK_AUTOHIDE_DURATION\"" \
    --run-cmd "defaults write com.apple.dock autohide-time-modifier -float $DOCK_AUTOHIDE_DURATION && killall Dock"

DOCK_HIDE_RECENT_APPS=false
run_task \
    --name "Set dock hide recent apps" \
    --check-cmd "defaults read com.apple.dock show-recents | grep -q \"$(bool_to_number "$DOCK_HIDE_RECENT_APPS")\"" \
    --run-cmd "defaults write com.apple.dock show-recents -bool $DOCK_HIDE_RECENT_APPS && killall Dock"

DOCK_MINIMIZE_ANIMATION=scale
run_task \
    --name "Set dock minimize animation" \
    --check-cmd "defaults read com.apple.dock mineffect | grep -q \"$DOCK_MINIMIZE_ANIMATION\"" \
    --run-cmd "defaults write com.apple.dock mineffect -string $DOCK_MINIMIZE_ANIMATION && killall Dock"

DRAG_WINDOW_ON_GESTURE=false
# Allows dragging a window by clicking anywhere on the window when cmd + ctrl is pressed
run_task \
    --name "Set drag window on gesture" \
    --check-cmd "defaults read -g NSWindowShouldDragOnGesture | grep -q \"$(bool_to_number "$DRAG_WINDOW_ON_GESTURE")\"" \
    --run-cmd "defaults write -g NSWindowShouldDragOnGesture -bool $DRAG_WINDOW_ON_GESTURE"

DEFAULT_FOLDER_VIEW_STYLE=clmv
run_task \
    --name "Set default folder view style" \
    --check-cmd "defaults read com.apple.finder FXPreferredViewStyle | grep -q \"$DEFAULT_FOLDER_VIEW_STYLE\"" \
    --run-cmd "defaults write com.apple.finder FXPreferredViewStyle -string $DEFAULT_FOLDER_VIEW_STYLE && killall Finder"


echo "🎉 All tasks completed successfully! 🎉"