#!/bin/bash
BASE_SESSION="main"

# Create base session if it doesn't exist, with destroy-unattached off
if ! tmux has-session -t $BASE_SESSION 2>/dev/null; then
    tmux new-session -d -s $BASE_SESSION
    tmux set-option -t $BASE_SESSION destroy-unattached off
fi

# Check if base session has any attached clients
if [ "$(tmux list-clients -t $BASE_SESSION 2>/dev/null | wc -l)" -eq 0 ]; then
    # No clients attached - connect to base session
    tmux attach-session -t $BASE_SESSION
else
    # Clients exist - create linked session with auto-cleanup
    LINKED_SESSION="linked_$(date +%s)"
    tmux new-session -t $BASE_SESSION -s $LINKED_SESSION
    tmux set-option -t $LINKED_SESSION destroy-unattached on
    tmux attach-session -t $LINKED_SESSION
fi

