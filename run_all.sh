#!/bin/bash

echo "[1] Parsing logs..."
./log_parser.sh

echo "[2] Blocking attackers..."
./block_ips.sh

echo "[3] Generating report..."
./report.sh

echo "Done! Full pipeline executed."
