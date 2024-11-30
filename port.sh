#!/bin/bash

# Custom Port Scanner Script

# Validate the number of arguments
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <IP_ADDRESS> <START_PORT> <END_PORT>"
  echo "Example: $0 192.168.1.1 20 80"
  exit 1
fi

# Assign arguments to variables
TARGET_IP=$1
START_PORT=$2
END_PORT=$3

# Validate port numbers are integers and within range
if ! [[ $START_PORT =~ ^[0-9]+$ && $END_PORT =~ ^[0-9]+$ && $START_PORT -ge 1 && $END_PORT -le 65535 && $START_PORT -le $END_PORT ]]; then
  echo "Error: Ports must be integers between 1 and 65535, and START_PORT <= END_PORT."
  exit 1
fi

echo "Starting port scan on $TARGET_IP from port $START_PORT to $END_PORT..."
START_TIME=$(date +%s)

# Scan each port in the specified range
for port in $(seq $START_PORT $END_PORT); do
  # Check port status using nc
  nc -z -v -w 1 $TARGET_IP $port 2>&1 | grep -q 'succeeded' && \
  echo "Port $port is OPEN" || \
  echo "Port $port is CLOSED"
done

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo "Port scan completed in $DURATION seconds."
