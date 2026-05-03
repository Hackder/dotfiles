#!/usr/bin/env bash

# Read JSON input from Claude Code
input=$(cat)

# Function to format tokens (K for thousands, M for millions)
format_tokens() {
    local num=$1
    if [ "$num" -ge 1000000 ]; then
        printf "%.1fM" "$(echo "scale=1; $num / 1000000" | bc)"
    elif [ "$num" -ge 1000 ]; then
        printf "%.1fK" "$(echo "scale=1; $num / 1000" | bc)"
    else
        echo "$num"
    fi
}

# Extract fields using jq if available, fallback to grep/sed
if command -v jq &>/dev/null; then
    model=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
    input_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
    output_tokens=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
    used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d'.' -f1)
    cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
else
    # Fallback to grep/sed for systems without jq
    model=$(echo "$input" | grep -o '"display_name":"[^"]*"' | head -1 | cut -d'"' -f4)
    input_tokens=$(echo "$input" | grep -o '"total_input_tokens":[0-9]*' | cut -d':' -f2)
    output_tokens=$(echo "$input" | grep -o '"total_output_tokens":[0-9]*' | cut -d':' -f2)
    used_pct=$(echo "$input" | grep -o '"used_percentage":[0-9.]*' | cut -d':' -f2 | cut -d'.' -f1)
    cost=$(echo "$input" | grep -o '"total_cost_usd":[0-9.]*' | cut -d':' -f2)

    # Set defaults if extraction failed
    model=${model:-"Unknown"}
    input_tokens=${input_tokens:-0}
    output_tokens=${output_tokens:-0}
    used_pct=${used_pct:-0}
    cost=${cost:-0}
fi

# Choose color based on context usage
if [ "$used_pct" -lt 50 ]; then
    COLOR="\033[32m" # Green
elif [ "$used_pct" -lt 80 ]; then
    COLOR="\033[33m" # Yellow
else
    COLOR="\033[31m" # Red
fi
RESET="\033[0m"

# Format the output
# Format: [Model] | ↓input ↑output | XX% used (remaining left) | $cost
printf "%b%s%b | ↓%s ↑%s | %b%d%%%b used | %.2f$\n" \
    "$COLOR" "$model" "$RESET" \
    "$(format_tokens $input_tokens)" \
    "$(format_tokens $output_tokens)" \
    "$COLOR" "$used_pct" "$RESET" \
    "$cost"
