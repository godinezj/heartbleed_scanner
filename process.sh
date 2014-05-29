#!/bin/bash

function do_work {
  ruby get_job.rb > input.txt
  ruby msf_scanner.rb input.txt > output.txt
  grep "\[+\]" output.txt|tr -cd '\11\12\15\40-\176'|cut -d\  -f1 --complement  > results.txt
  ruby send_results.rb results.txt
  rm results.txt output.txt input.txt
}

while true; do 
  do_work
done