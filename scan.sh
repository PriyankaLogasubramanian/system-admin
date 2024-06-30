#!/bin/bash

# Define log files
AUTH_LOG="/var/log/auth.log"
UNAUTHORIZED_LOG="/var/webserver_log/unauthorized.log"
TEMP_LOG="/var/webserver_log/temp.log"
LAST_LINE_FILE="/var/webserver_log/last_line.log"

# Get the last processed line number, default to 0 if not found
if [ -f $LAST_LINE_FILE ]; then
    LAST_LINE=$(cat $LAST_LINE_FILE)
else
    LAST_LINE=0
fi

# Get the current number of lines in the auth.log
CURRENT_LINE=$(wc -l < $AUTH_LOG)

# Extract new lines from the auth.log
if [ $CURRENT_LINE -gt $LAST_LINE ]; then
     sed -n "$((LAST_LINE + 1)),$CURRENT_LINE p" $AUTH_LOG | grep "Failed password" | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' > $TEMP_LOG
fi

# Update the last processed line number
echo $CURRENT_LINE > $LAST_LINE_FILE

# Remove duplicate IPs
sort -u $TEMP_LOG -o $TEMP_LOG

# Get the current date
DATE=$(date "+%Y-%m-%d %H:%M:%S")

# Check each IP and determine the country
while IFS= read -r IP; do
    # Use a geolocation service to get the country of origin
    COUNTRY=$(curl -s https://ipapi.co/$IP/country_name/)

    # Append the result to unauthorized.log
    echo "$IP $COUNTRY $DATE" >> $UNAUTHORIZED_LOG
done < $TEMP_LOG

# Clean up
rm $TEMP_LOG
