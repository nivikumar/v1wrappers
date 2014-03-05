# This is an example of how to use the VerticalResponse Ruby API wrapper,
# specifically related to error handling.
#
# Before you run this example, you need to modify the following config file and
# include your access tokens for the user you have created in VerticalResponse:
#   ../config/api.yml
#
# The idea behind this example is to show you how errors are handled by the
# Ruby wrapper, and how you can get the information from those errors to use
# it in your application.
#
# We will cover the following pieces of information that you can get from an
# error object: (exception)
#
# 1. The error object contains both the error message and code returned by the API
# 2. The error object includes the original API response object, so you can also
# get whatever information the response has (links, error details by field, etc.)
#
#
# To run this example, simply execute this file with Ruby. e.g.
#   ruby examples/errors.rb

require 'pp'
require_relative '../lib/list'

def display_result(message, result)
  puts message
  pp result
  puts
  puts
end

# 1. The error object contains both the error message and code returned by the API
begin
  puts 'Trying to create a contact with a blank email...'
  VerticalResponse::API::Contact.create({ :email_address => '' })
rescue VerticalResponse::API::Error => error
  puts "Error code is: #{ error.code }"
  puts "Error message is: #{ error.message }"
  puts
end

# 2. The error object includes the original API response object
begin
  puts 'Trying to create a list with a blank name...'
  VerticalResponse::API::List.create({ :name => '' })
rescue VerticalResponse::API::Error => error
  display_result('Original API response:', error.api_response)
  display_result('Error object:', error)
end

