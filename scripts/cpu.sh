#!/bin/bash

echo "================================"
echo "          CPU MONITOR"
echo "================================"

cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')

printf "CPU Usage : %.2f%%\n" "$cpu_usage"

if (( $(echo "$cpu_usage > 80" | bc -l) )); then
    echo "Status    : WARNING - High CPU Usage!"
else
    echo "Status    : NORMAL"
fi

echo "================================"
