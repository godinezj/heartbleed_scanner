#!/bin/bash

# make sure only one job runs at the time
touch running.lock
date  >> results-history.log
cat results.txt >> results-history.log
rm results.txt

# scan the ranges or ip addresses in all-ranges.txt
nmap -n -PN -p443 -sT --randomize-hosts -oG scan-results.txt -T5 \
  --open -iL all-ranges.txt --excludefile exclude-hosts.txt

# parse the results
grep -v \# scan-results.txt | grep open/tcp |cut -f2 -d\  > live-hosts.txt
echo "Finished initial portscan"

# queue up the jobs and retrieve results
echo "Queueing up the jobs and retrieving results, please wait..."
ruby add_jobs.rb live-hosts.txt > results.txt

rm -f running.lock