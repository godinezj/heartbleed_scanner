#!/usr/bin/ruby
require 'aws-sdk'

AWS.config(:region => ENV['AWS_REGION'],
           :proxy_uri => ENV['https_proxy'],
           :credential_provider => AWS::Core::CredentialProviders::EC2Provider.new)
sqs = AWS::SQS.new()
res_url = ENV['RESPONSE_QUEUE_URL']
req_url = ENV['REQUEST_QUEUE_URL']
res_q = sqs.queues[res_url]
req_q = sqs.queues[req_url]

jobs=0
# Expects a file name with IP addresses, one per line
ARGV.each { |file_name|
  file = File.open(file_name, 'r')
  file.readlines.each_slice(100) {|slice| 
    req_q.send_message slice.join() 
    jobs+=1
  }
  file.close
}

res_q.poll() { |msg|
  body = msg.body
  if body != "NOOP"
    puts body
  end
  jobs-=1

  if jobs == 0
    msg.delete
    break
  end
}

puts "Done!"