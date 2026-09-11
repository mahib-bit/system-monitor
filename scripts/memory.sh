#!/bin/bash

echo "================================"
echo "        MEMORY MONITOR"
echo "================================"

memory_usage=$(free | awk '/Mem:/ {printf "%.2f", $3/$2 * 100}')

printf "RAM Usage : %.2f%%\n" "$memory_usage"

if (( $(echo "$memory_usage > 80" | bc -l) )); then
    echo "Status    : WARNING - High RAM Usage!"
else
    echo "Status    : NORMAL"
fi

echo "================================"
