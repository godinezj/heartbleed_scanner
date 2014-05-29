#!/usr/bin/ruby
require 'rubygems'
require 'aws-sdk'

AWS.config(:region => ENV['AWS_REGION'],
           :proxy_uri => ENV['https_proxy'],
           :credential_provider => AWS::Core::CredentialProviders::EC2Provider.new)
sqs = AWS::SQS.new()
url = ENV['RESPONSE_QUEUE_URL']


ARGV.each { |file_name|
  if !File.zero?(file_name)
    file = File.open(file_name, 'r')
    sqs.queues[url].send_message(file.read)
    file.close
  end
}
