#!/usr/bin/ruby
require 'aws-sdk'

AWS.config(:access_key_id => ENV['AWS_ACCESS_KEY_ID'],
           :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
           :region => ENV['AWS_REGION'],
           :proxy_uri => ENV['https_proxy'])#,
           # :credential_provider => AWS::Core::CredentialProviders::EC2Provider.new)
sqs = AWS::SQS.new()
url = ENV['REQUEST_QUEUE_URL']

# Expects a file name with IP addresses, one per line
ARGV.each { |file_name|
  file = File.open(file_name, 'r')
  file.readlines.each_slice(50) {|slice| sqs.queues[url].send_message slice.join() }
  file.close
}
