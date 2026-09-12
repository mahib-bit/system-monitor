#!/bin/bash

echo "=============================================="
echo "              SYSTEM INFORMATION"
echo "=============================================="
echo

# Show the operating system name
printf "Operating System : "
grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2- | tr -d '"'

# Show the computer hostname
printf "Hostname         : %s\n" "$(hostname)"

# Show the Linux kernel version
printf "Kernel           : %s\n" "$(uname -r)"

# Show the system architecture
printf "Architecture     : %s\n" "$(uname -m)"

# Show the number of CPU cores
printf "CPU Cores        : %s\n" "$(nproc)"

# Show total RAM
printf "Total RAM        : "
free -h | awk '/Mem:/ {print $2}'

# Show how long the system has been running
printf "Uptime           : %s\n" "$(uptime -p)"

echo
echo "=============================================="

# Wait before returning to the menu
read -p "Press Enter to return to menu..."
