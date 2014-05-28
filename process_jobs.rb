#!/usr/bin/ruby
require 'aws-sdk'
require './msf_scanner'

AWS.config(:region => ENV['AWS_REGION'],
           :proxy_uri => ENV['https_proxy'],
           :credential_provider => AWS::Core::CredentialProviders::EC2Provider.new)
sqs = AWS::SQS.new()
url = ENV['REQUEST_QUEUE_URL']

scanner = MsfScanner.new()
sqs.queues[url].poll { |msg|
 ip_addresses = msg.body.split(/\n/)
 ip_addresses.each { |ip|
  scanner.scan(ip)
 }
}
