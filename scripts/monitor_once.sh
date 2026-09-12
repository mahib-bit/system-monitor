#!/bin/bash

# Find the folder where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Find the project folder
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Load configuration values
source "$PROJECT_DIR/config/config.conf"


# ==========================================
# Function to create a usage bar
# ==========================================

create_bar() {

    # Percentage received by the function
    percentage=$1

    # Calculate how many blocks should be filled
    filled=$(awk "BEGIN {printf \"%d\", $percentage / 5}")

    # Calculate how many blocks should remain empty
    empty=$((20 - filled))

    # Start with an empty bar
    bar=""

    # Add filled blocks
    for ((i=0; i<filled; i++))
    do
        bar="${bar}█"
    done

    # Add empty blocks
    for ((i=0; i<empty; i++))
    do
        bar="${bar}░"
    done

    echo "$bar"
}


# ==========================================
# Get system information
# ==========================================

# Get CPU usage
cpu_usage=$(top -bn1 | awk '/Cpu\(s\)/ {printf "%.2f", $2 + $4 + $6}')

# Get RAM usage
memory_usage=$(free | awk '/Mem:/ {printf "%.2f", $3/$2 * 100}')

# Get disk usage
disk_usage=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')


# Create usage bars
cpu_bar=$(create_bar "$cpu_usage")
memory_bar=$(create_bar "$memory_usage")
disk_bar=$(create_bar "$disk_usage")


# ==========================================
# Display dashboard
# ==========================================

echo "=============================================="
echo "          CURRENT RESOURCE USAGE"
echo "=============================================="
echo

printf "CPU Usage  : %6.2f%% [%s]\n" "$cpu_usage" "$cpu_bar"
printf "RAM Usage  : %6.2f%% [%s]\n" "$memory_usage" "$memory_bar"
printf "Disk Usage : %6s%% [%s]\n" "$disk_usage" "$disk_bar"

echo


# ==========================================
# Check CPU
# ==========================================

if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )); then
    echo "CPU Status  : WARNING"
else
    echo "CPU Status  : NORMAL"
fi


# ==========================================
# Check RAM
# ==========================================

if (( $(echo "$memory_usage > $RAM_THRESHOLD" | bc -l) )); then
    echo "RAM Status  : WARNING"
else
    echo "RAM Status  : NORMAL"
fi


# ==========================================
# Check Disk
# ==========================================

if [ "$disk_usage" -gt "$DISK_THRESHOLD" ]; then
    echo "Disk Status : WARNING"
else
    echo "Disk Status : NORMAL"
fi


echo
echo "=============================================="

# Wait for user
read -p "Press Enter to return to menu..."
