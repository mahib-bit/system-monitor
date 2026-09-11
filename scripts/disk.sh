#!/bin/bash

echo "================================"
echo "         DISK MONITOR"
echo "================================"

disk_usage=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

printf "Disk Usage : %s%%\n" "$disk_usage"

if [ "$disk_usage" -gt 80 ]; then
    echo "Status     : WARNING - High Disk Usage!"
else
    echo "Status     : NORMAL"
fi

echo "================================"
