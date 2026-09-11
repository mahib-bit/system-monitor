#!/bin/bash

# Location of the log file
LOG_FILE="../logs/resource_usage.csv"

# Location where the report will be saved
REPORT_FILE="../reports/performance_report.txt"

# Check if the log file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "No monitoring data found."
    exit 1
fi

# Calculate average CPU usage
average_cpu=$(awk -F',' 'NR > 1 {sum += $3; count++} END {if (count > 0) printf "%.2f", sum/count}' "$LOG_FILE")

# Calculate average RAM usage
average_ram=$(awk -F',' 'NR > 1 {sum += $4; count++} END {if (count > 0) printf "%.2f", sum/count}' "$LOG_FILE")

# Calculate average Disk usage
average_disk=$(awk -F',' 'NR > 1 {sum += $5; count++} END {if (count > 0) printf "%.2f", sum/count}' "$LOG_FILE")

# Count the number of monitoring records
total_records=$(awk -F',' 'NR > 1 {count++} END {print count}' "$LOG_FILE")

# Create the report
{
    echo "========================================"
    echo "       SYSTEM PERFORMANCE REPORT"
    echo "========================================"
    echo
    echo "Total Monitoring Records : $total_records"
    echo
    echo "Average CPU Usage  : $average_cpu%"
    echo "Average RAM Usage  : $average_ram%"
    echo "Average Disk Usage : $average_disk%"
    echo
    echo "========================================"
    echo "Report generated on: $(date)"
    echo "========================================"
} > "$REPORT_FILE"

# Tell the user where the report was created
echo "Performance report generated successfully."
echo "Report saved to: $REPORT_FILE"
