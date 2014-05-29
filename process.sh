#!/bin/bash

cd /home/ec2-user/heartbleed_scanner
git pull
ruby process_job.rb