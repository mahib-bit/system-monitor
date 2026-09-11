
#!/bin/bash

# Load configuration values
source ../config/config.conf

# Clear the terminal
clear

# Get CPU usage
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')

# Get RAM usage
memory_usage=$(free | awk '/Mem:/ {printf "%.2f", $3/$2 * 100}')

# Get disk usage
disk_usage=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

# Get current date
current_date=$(date +"%Y-%m-%d")

# Get current time
current_time=$(date +"%H:%M:%S")

# Save monitoring data to CSV file
echo "$current_date,$current_time,$cpu_usage,$memory_usage,$disk_usage" >> ../logs/resource_usage.csv

# Display dashboard
echo "========================================"
echo "       SYSTEM RESOURCE MONITOR"
echo "========================================"
echo

printf "CPU Usage  : %.2f%%\n" "$cpu_usage"
printf "RAM Usage  : %.2f%%\n" "$memory_usage"
printf "Disk Usage : %s%%\n" "$disk_usage"

echo

echo
echo "Thresholds:"
echo "CPU  : $CPU_THRESHOLD%"
echo "RAM  : $RAM_THRESHOLD%"
echo "Disk : $DISK_THRESHOLD%"



# CPU status
if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )); then
    echo "CPU Status  : WARNING"

     # Save CPU warning to alert log
    echo "$current_date $current_time - WARNING: CPU usage is ${cpu_usage}%" >> ../logs/alerts.log

else
    echo "CPU Status  : NORMAL"
fi

# RAM status
if (( $(echo "$memory_usage > $RAM_THRESHOLD" | bc -l) )); then
    echo "RAM Status  : WARNING"

     # Save RAM warning to alert log
    echo "$current_date $current_time - WARNING: RAM usage is ${memory_usage}%" >> ../logs/alerts.log

else
    echo "RAM Status  : NORMAL"
fi

# Disk status
if [ "$disk_usage" -gt "$DISK_THRESHOLD" ]; then
    echo "Disk Status : WARNING"

    # Save disk warning to alert log
    echo "$current_date $current_time - WARNING: Disk usage is ${disk_usage}%" >> ../logs/alerts.log

else
    echo "Disk Status : NORMAL"
fi

echo
echo "========================================"
