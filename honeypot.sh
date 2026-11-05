#!/bin/bash

PORT=2222
LOGFILE="honeypot.log"

echo "[*] Starting honeypot on port $PORT..."
echo "[*] Logging connections to $LOGFILE"

while true
do
	nc -l -p $PORT -n -v >> /dev/null 2>&1 &
	PID=$!

	wait $PID

	TIME=$(date "+%Y-%m-%d %H:%M:%S")

	IP=$(netstat -tn 2>/dev/null | grep ":$PORT" | awk '{print $5}' | cut -d: -f1 | tail -n 1)

	if [ ! -z "$IP" ]
	then
		echo "$TIME - Connection attempt from $IP" >> $LOGFILE
		echo "[+] $TIME -Connection attempt from $IP"
	fi
done
