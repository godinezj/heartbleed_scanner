#!/bin/bash

function do_work {
  ruby get_job.rb > input.txt
  ruby msf_scanner.rb input.txt > output.txt
  grep "[+]" output.txt > results.txt
  ruby send_results.rb results.txt
  rm results.txt output.txt input.txt
}

while true; do 
  do_work
done