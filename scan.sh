#!/bin/bash
nmap -n -PN -p443 -sT --randomize-hosts -oG results.txt \
  --open -iL all-ranges.txt --excludefile exclude-hosts.txt
grep -v \# results.txt | grep open/tcp |cut -f2 -d\  > live-hosts.txt
ruby add_jobs.rb live-hosts.txt



