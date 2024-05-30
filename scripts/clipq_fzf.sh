#!/bin/bash

# Use copyq to list clipboard entries and fzf to select one
selected=$(copyq list | fzf --reverse --prompt="Select clipboard entry: ")

# If an entry is selected, paste it
if [[ -n "$selected" ]]; then
    # Extract the entry number from the selection
    entry_number=$(echo "$selected" | awk '{print $1}')
    # Retrieve the entry content
    entry_content=$(copyq read $entry_number)
    # Load the entry content into tmux buffer and paste it
    echo -n "$entry_content" | tmux load-buffer - && tmux paste-buffer
fi
