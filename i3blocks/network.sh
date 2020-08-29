#!/bin/bash -eu
echo "$(ip -f inet -o addr | grep -v "127.0.0.1" | cut -d\  -f 7 | cut -d/ -f 1 | awk 'NR == 1')"

