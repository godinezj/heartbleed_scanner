#!/usr/bin/ruby
require 'aws-sdk'

AWS.config(:region => ENV['AWS_REGION'],
           :proxy_uri => ENV['https_proxy'],
           :credential_provider => AWS::Core::CredentialProviders::EC2Provider.new)
sqs = AWS::SQS.new()
url = ENV['REQUEST_QUEUE_URL']

# Expects a file name with IP addresses, one per line
ARGV.each { |file_name|
  file = File.open(file_name, 'r')
  file.readlines.each_slice(100) {|slice| sqs.queues[url].send_message slice.join() }
  file.close
}
