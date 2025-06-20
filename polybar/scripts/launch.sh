#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch polybar based on connected monitors
if [[ $(xrandr -q | grep -c " connected") -eq 2 ]]; then
    # Two monitors connected
    PRIMARY=$(xrandr -q | grep " connected primary" | cut -d ' ' -f1)
    SECONDARY=$(xrandr -q | grep " connected" | grep -v "primary" | head -n 1 | cut -d ' ' -f1)
    
    # Launch polybar on each monitor
    MONITOR=$PRIMARY polybar main &
    MONITOR=$SECONDARY polybar secondary &
    
    echo "Launched polybar on multiple monitors"
else
    # Single monitor setup
    polybar main &
    echo "Launched polybar on single monitor"
fi
