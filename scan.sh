#!/bin/bash

# make sure only one job runs at the time
touch running.lock

# scan the ranges or ip addresses in all-ranges.txt
nmap -n -PN -p443 -sT --randomize-hosts -oG scan-results.txt -T5 \
  --open -iL all-ranges.txt --excludefile exclude-hosts.txt

# parse the results
grep -v \# scan-results.txt | grep open/tcp |cut -f2 -d\  > live-hosts.txt

# queue up the jobs and retrieve results
ruby add_jobs.rb live-hosts.txt
ruby get_results.rb > results.txt

rm -f running.lock