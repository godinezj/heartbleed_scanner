#!/usr/bin/ruby
require 'rubygems'
require 'aws-sdk'

AWS.config(:region => ENV['AWS_REGION'],
           :proxy_uri => ENV['https_proxy'],
           :credential_provider => AWS::Core::CredentialProviders::EC2Provider.new)
sqs = AWS::SQS.new()
url = ENV['REQUEST_QUEUE_URL']

sqs.queues[url].receive_message() { |msg|
 puts msg.body
}