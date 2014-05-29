#!/usr/bin/ruby
require 'rubygems'
require 'aws-sdk'

AWS.config(:region => ENV['AWS_REGION'],
           :proxy_uri => ENV['https_proxy'],
           :credential_provider => AWS::Core::CredentialProviders::EC2Provider.new)
sqs = AWS::SQS.new()
res_url = ENV['RESPONSE_QUEUE_URL']
req_uel = ENV['REQUEST_QUEUE_URL']
res_q = sqs.queues[res_url]
req_q = sqs.queues[req_url]

while req_q.visible_messages > 0 and res_q.visible_messages > 0 do
  res_q.receive_message(:wait_time_seconds => 60) { |msg|
    puts msg.body
  }
  sleep 60
end

sleep 120
res_q.receive_message(:wait_time_seconds => 60) { |msg|
  puts msg.body
}

puts "Done!"
