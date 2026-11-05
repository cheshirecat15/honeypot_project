#!/bin/bash
LOGFILE="honeypot.log"
WHITELIST=("127.0.0.1")
BLOCKLIST="block_ips.txt"
THRESHOLD=5

if [ ! -f "$LOGFILE" ]
then
	echo "[!] Log file not found."
	exit 1
fi

SUSPICIOUS_IPS=$(awk '{print $NF}' "$RECENT_LOG" | sort | uniq -c | awk -v t=$THRESHOLD '$1 >= t {print $2}')

WINDOW_MINUTES=5

CURRENT_TIME=$(date +%s)
TIME_LIMIT=$((CURRENT_TIME - WINDOW_MINUTES * 60))

RECENT_LOG="recent_log.tmp"

while IFS= read -r line
do
	LOG_TIME=$(echo "$line" | awk '{print $1" "$2}')
	LOG_TIME_EPOCH=$(date -d "$LOG_TIME" +%s 2>/dev/null)

	if [ "$LOG_TIME_EPOCH" -ge "$TIME_LIMIT" ]
	then
		echo "$line" >> "$RECENT_LOG"
	fi
done< "$LOGFILE"


for IP in $SUSPICIOUS_IPS
do
	#skip whitelist
	if [[" ${WHITELIST[@]} " =~ " ${IP}" ]]
	then
		echo "[INFO] $IP is in whitelist. Skipping."
		continue
	fi

	#check if already blocked
	if grep -q "$IP" "$BLOCKLIST" 2>/dev/null
	then
		echo "[INFO] $IP already blocked."
		continue
	fi

	#block using iptables
	sudo iptables -A INPUT -s $IP -j DROP
	echo "[BLOCKED] $IP blocked using iptables."

	#ADD TO BLOCKLIST
	echo "$IP" >> "$BLOCKLIST"
done


