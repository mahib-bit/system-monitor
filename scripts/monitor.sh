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

    # Get percentage
    percentage=$1

    # Calculate filled blocks
    filled=$(awk "BEGIN {printf \"%d\", $percentage / 5}")

    # Prevent more than 20 blocks
    if [ "$filled" -gt 20 ]; then
        filled=20
    fi

    # Calculate empty blocks
    empty=$((20 - filled))

    # Create empty bar
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
# Continuous monitoring
# ==========================================

while true
do

    # Clear terminal
    clear

    # Get CPU usage
    cpu_usage=$(top -bn1 | awk '/Cpu\(s\)/ {printf "%.2f", $2 + $4 + $6}')

    # Get RAM usage
    memory_usage=$(free | awk '/Mem:/ {printf "%.2f", $3/$2 * 100}')

    # Get disk usage
    disk_usage=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

    # Get current date
    current_date=$(date +"%Y-%m-%d")

    # Get current time
    current_time=$(date +"%H:%M:%S")

    # Create usage bars
    cpu_bar=$(create_bar "$cpu_usage")
    memory_bar=$(create_bar "$memory_usage")
    disk_bar=$(create_bar "$disk_usage")


    # ==========================================
    # Save usage to CSV
    # ==========================================

    echo "$current_date,$current_time,$cpu_usage,$memory_usage,$disk_usage" >> "$PROJECT_DIR/logs/resource_usage.csv"


    # ==========================================
    # Display dashboard
    # ==========================================

    echo "=============================================="
    echo "          SYSTEM RESOURCE MONITOR"
    echo "=============================================="
    echo
    echo "Time: $current_date $current_time"
    echo

    printf "CPU Usage  : %6.2f%% [%s]\n" "$cpu_usage" "$cpu_bar"
    printf "RAM Usage  : %6.2f%% [%s]\n" "$memory_usage" "$memory_bar"
    printf "Disk Usage : %6s%% [%s]\n" "$disk_usage" "$disk_bar"

    echo
    echo "Thresholds:"
    echo "CPU  : $CPU_THRESHOLD%"
    echo "RAM  : $RAM_THRESHOLD%"
    echo "Disk : $DISK_THRESHOLD%"
    echo


    # ==========================================
    # CPU check
    # ==========================================

    if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )); then

        echo "CPU Status  : WARNING"

        if ! grep -q "^CPU_WARNING" "$PROJECT_DIR/logs/alert_state.txt"; then

            echo "CPU_WARNING" >> "$PROJECT_DIR/logs/alert_state.txt"

            echo "$current_date $current_time - WARNING: CPU usage is ${cpu_usage}%" >> "$PROJECT_DIR/logs/alerts.log"

        fi

    else

        echo "CPU Status  : NORMAL"

        sed -i '/^CPU_WARNING$/d' "$PROJECT_DIR/logs/alert_state.txt"

    fi


    # ==========================================
    # RAM check
    # ==========================================

    if (( $(echo "$memory_usage > $RAM_THRESHOLD" | bc -l) )); then

        echo "RAM Status  : WARNING"

        if ! grep -q "^RAM_WARNING" "$PROJECT_DIR/logs/alert_state.txt"; then

            echo "RAM_WARNING" >> "$PROJECT_DIR/logs/alert_state.txt"

            echo "$current_date $current_time - WARNING: RAM usage is ${memory_usage}%" >> "$PROJECT_DIR/logs/alerts.log"

        fi

    else

        echo "RAM Status  : NORMAL"

        sed -i '/^RAM_WARNING$/d' "$PROJECT_DIR/logs/alert_state.txt"

    fi


    # ==========================================
    # Disk check
    # ==========================================

    if [ "$disk_usage" -gt "$DISK_THRESHOLD" ]; then

        echo "Disk Status : WARNING"

        if ! grep -q "^DISK_WARNING" "$PROJECT_DIR/logs/alert_state.txt"; then

            echo "DISK_WARNING" >> "$PROJECT_DIR/logs/alert_state.txt"

            echo "$current_date $current_time - WARNING: Disk usage is ${disk_usage}%" >> "$PROJECT_DIR/logs/alerts.log"

        fi

    else

        echo "Disk Status : NORMAL"

        sed -i '/^DISK_WARNING$/d' "$PROJECT_DIR/logs/alert_state.txt"

    fi


    echo
    echo "=============================================="
    echo "Next update in 5 seconds..."
    echo "Press Ctrl+C to stop."
    echo "=============================================="

    sleep 5

done
