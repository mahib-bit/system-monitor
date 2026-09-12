#!/bin/bash

while true
do
    clear

    echo "=============================================="
    echo "       SYSTEM RESOURCE MONITORING"
    echo "=============================================="
    echo
    echo "1. Show Current Usage"
    echo "2. Start Continuous Monitoring"
    echo "3. View Usage Logs"
    echo "4. View Alerts"
    echo "5. Generate Performance Report"
    echo "6. System Information"
    echo "7. Clear Logs"
    echo "8. View Configuration"
    echo "9. Exit"
    echo
    read -p "Enter your choice: " choice

    case $choice in

        1)
            ./monitor_once.sh
            ;;

        2)
            ./monitor.sh
            ;;

        3)
            clear
            echo "=============================================="
            echo "               USAGE LOGS"
            echo "=============================================="
            echo
            cat ../logs/resource_usage.csv
            echo
            read -p "Press Enter to return to menu..."
            ;;

        4)
            clear
            echo "=============================================="
            echo "                  ALERTS"
            echo "=============================================="
            echo
            cat ../logs/alerts.log
            echo
            read -p "Press Enter to return to menu..."
            ;;

        5)
            ./report.sh
            ;;

        6)
            ./system_info.sh
            ;;

        7)
            clear
            echo "Clearing logs..."

            # Keep the CSV header
            head -n 1 ../logs/resource_usage.csv > /tmp/resource_usage.csv
            mv /tmp/resource_usage.csv ../logs/resource_usage.csv

            # Clear alert logs
            > ../logs/alerts.log
            > ../logs/alert_state.txt

            echo "Logs cleared successfully."
            read -p "Press Enter to return to menu..."
            ;;

        8)
            clear
            echo "=============================================="
            echo "              CONFIGURATION"
            echo "=============================================="
            echo
            cat ../config/config.conf
            echo
            read -p "Press Enter to return to menu..."
            ;;

        9)
            echo
            echo "Exiting System Resource Monitoring..."
            exit 0
            ;;

        *)
            echo
            echo "Invalid choice. Please try again."
            sleep 2
            ;;

    esac
done
