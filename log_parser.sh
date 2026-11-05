#!/bin/bash
# this file analyzes honeypot logs and summarizes attacker activity

LOGFILE="honeypot.log"

if [ ! -f "$LOGFILE" ]
then
	echo "[!] Log file not found: $LOGFILE"
	exit 1
fi

echo "=== Honeypot Log Summary ==="
echo

Total=$(wc -l < "$LOGFILE")
echo "Total connection attempts: $TOTAL"
echo

echo "Top attackers:"
awk '{print $6}' "$LOGFILE" | sort | uniq -c | sort -nr | head -10
echo

echo "Suspicious IPs (>=5 attempts):"
awk '{print $6}' "$LOGFILE" | sort | uniq -c | awk '$1 >= 5 {print $2}'
