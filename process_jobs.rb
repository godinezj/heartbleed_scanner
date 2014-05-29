#!/usr/bin/ruby
require 'rubygems'
require 'aws-sdk'
require './msf_scanner'

AWS.config(:region => ENV['AWS_REGION'],
           :proxy_uri => ENV['https_proxy'],
           :credential_provider => AWS::Core::CredentialProviders::EC2Provider.new)
sqs = AWS::SQS.new()
url = ENV['REQUEST_QUEUE_URL']

while true do
  begin 
    scanner = MsfScanner.new()
    sqs.queues[url].poll(:initial_timeout => false, :idle_timeout => 60) { |msg|
     ip_addresses = msg.body.split(/\n/)
     ip_addresses.each { |ip|
      scanner.scan(ip)
     }
    }
  rescue Exception => e
    puts e.message  
    puts e.backtrace.inspect 
  end
end