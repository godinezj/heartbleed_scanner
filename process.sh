#!/bin/bash

function do_work {
  ruby get_job.rb > input.txt
  if [ $? -eq 0 ]; then 
    ruby msf_scanner.rb input.txt > output.txt
    grep "\[+\]" output.txt|tr -cd '\11\12\15\40-\176'|cut -d\  -f1 --complement|sort|uniq  > results.txt
    ruby send_results.rb results.txt
    date  >> results-history.log
    cat results.txt output.txt input.txt >> results-history.log
    rm -f results.txt output.txt input.txt
  fi
}

while true; do 
  do_work
done