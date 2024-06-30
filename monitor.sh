#!/bin/bash

# Define log file paths
UNAUTHORIZED_LOG="/var/webserver_monitor/unauthorized.log"
LAST_CHECKED_FILE="/var/webserver_monitor/last_checked.log"

# Get the current date and time
DATE=$(date "+%Y-%m-%d %H:%M:%S")

# If last_checked.log does not exist, create it and set the initial value to 0
if [ ! -f $LAST_CHECKED_FILE ]; then
    echo "0" > $LAST_CHECKED_FILE
fi

# Get the last checked line number
LAST_CHECKED=$(cat $LAST_CHECKED_FILE)

# Get the current number of lines in the unauthorized.log
CURRENT_LINE=$(wc -l < $UNAUTHORIZED_LOG)

# Check if there are new entries
if [ $CURRENT_LINE -gt $LAST_CHECKED ]; then
    # Get the new entries
    NEW_ENTRIES=$(sed -n "$((LAST_CHECKED + 1)),$CURRENT_LINE p" $UNAUTHORIZED_LOG)
    # Send an email with the new entries
    echo "$NEW_ENTRIES" | mail -s "New Unauthorized Access Entries - $DATE" PL1032847@wcupa.edu
    # Update the last checked line number
    echo $CURRENT_LINE > $LAST_CHECKED_FILE
else
    # Send an email saying "No unauthorized access"
    echo "No unauthorized access." | mail -s "No Unauthorized Access - $DATE" PL1032847@wcupa.edu
fi
