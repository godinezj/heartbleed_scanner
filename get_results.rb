#!/usr/bin/ruby
require 'rubygems'
require 'aws-sdk'

AWS.config(:region => ENV['AWS_REGION'],
           :proxy_uri => ENV['https_proxy'],
           :credential_provider => AWS::Core::CredentialProviders::EC2Provider.new)
sqs = AWS::SQS.new()
res_url = ENV['RESPONSE_QUEUE_URL']
req_url = ENV['REQUEST_QUEUE_URL']
res_q = sqs.queues[res_url]
req_q = sqs.queues[req_url]

puts "Request queue has #{req_q.visible_messages} messages, Response queue has #{res_q.visible_messages} messages"
while req_q.visible_messages > 0 || res_q.visible_messages > 0 do
  puts "Request queue has #{req_q.visible_messages} messages, Response queue has #{res_q.visible_messages} messages"
  res_q.receive_message(:wait_time_seconds => 20) { |msg|
    puts msg.body
  }
  sleep 60
end

sleep 120
if req_q.visible_messages > 0
  res_q.receive_message(:wait_time_seconds => 20) { |msg|
    puts msg.body
  }
end

puts "Done!"
