#!/bin/bash

LOGFILE="honeypot.log"
BLOCKLIST="blocked_ips.txt"
REPORT="final_report.txt"

echo "==== Honeypot Security Report ====">$REPORT
echo "Generated on: $(date)" >> $REPORT
echo "-------------------------------------">>$REPORT

if [ ! -f "$LOGFILE" ]
then
	echo "[!] No log file found. ">> $REPORT
	exit 1
fi

# Total attempts
TOTAL=$(wc -l < "$LOGFILE")
echo "Total Connection Attempts: $TOTAL" >> $REPORT
echo "" >> $REPORT

echo "Top Attackers:" >> $REPORT
awk '{print $NF}' "$LOGFILE" | sort | uniq -c | sort -n | head -10 >> $REPORT
echo "" >> $REPORT

echo "Blocked IPs (Attempted >=5 times):" >> $REPORT
if [ -f "$BLOCKLIST" ]
then
	cat "$BLOCKLIST" >> $REPORT
else
	echo "No IPs blocked yet." >> $REPORT
fi

echo "" >> $REPORT
echo "-------------------------------------------" >> $REPORT
echo "End of Report.">>$REPORT
