# This is an example of how to use the VerticalResponse Ruby API wrapper
# in its most basic form.
#
# Before you run this example, you need to modify the following config file and
# include your access tokens for the user you have created in VerticalResponse:
#   ../config/api.yml
#
# The example consists of performing the following operations for the user:
#
# 1. Create a list (raw JSON response)
# 2. Get all lists, including the new one you just created (with response object)
# 3. Get all lists using pagination (raw JSON response)
# 4. Create a contact on the list (with response object)
# 5. Get all contacts for the list (raw JSON response)
# 6. Get the full details of the contact you just created (with response object)
# 7. Create a general contact (without specifying a list - with response object)
# 8. Get all contacts for the user (with response object)
# 9. Create an email (raw JSON response)
# 10. Launch the email you just created (with response object)
# 11. Get the summary stats for the email (with response object)
#
# To run this example, simply execute this file with Ruby. e.g.
#   ruby examples/client.rb
#
# Checkout the other examples (lists.rb and contacts.rb) to see how to perform
# some of these actions in an object oriented way.

require 'pp'
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'client'))

def display_result(message, result)
  puts message
  pp result
  puts
  puts
end

client_class = VerticalResponse::API::Client
# Also defined in List.resource_uri:
lists_uri = File.join(client_class.base_uri.to_s, 'lists')
# Also defined in Contact.resource_uri:
contacts_uri = File.join(client_class.base_uri.to_s, 'contacts')
# Also defined in Email.resource_uri:
emails_uri = File.join(client_class.base_uri.to_s, 'messages', 'emails')

# 1. Create a list
created_list_raw_response = client_class.post(
  lists_uri,
  client_class.build_params(
    { :name => "Test list #{ Time.now.to_i }" }
  )
)
display_result('Created list response: (raw JSON)', created_list_raw_response)

# 2. Get all lists, including the new one you just created.
# Here we are using the response wrapper object instead of the raw JSON response
lists_response = VerticalResponse::API::Response.new client_class.get(lists_uri)
display_result('All lists, including the new one:', lists_response)

# 3. Get all lists using pagination - from list 5 to 10
paginated_lists_raw_response = client_class.get(
  client_class.uri_with_options(
    lists_uri,
    { :index => 5, :limit => 5 }
  )
)
display_result('All lists with pagination: (raw JSON response)',
               paginated_lists_raw_response)

# 4. Create a contact on the list
# Here we are using the response wrapper object instead of the raw JSON response
created_contact_response = VerticalResponse::API::Response.new client_class.post(
  File.join(created_list_raw_response['url'], 'contacts'),
  client_class.build_params(
    { :email => "test_list_#{ Time.now.to_i }@verticalresponse.com" }
  )
)
display_result('Created contact response:', created_contact_response)

# 5. Get all contacts for the list
list_contacts_raw_response = client_class.get(
  File.join(created_list_raw_response['url'], 'contacts')
)
display_result('All contacts for the list: (raw JSON response)',
               list_contacts_raw_response)

# 6. Get the full details of the contact you just created
# Here we are using the response wrapper object instead of the raw JSON response
detailed_contact_response = VerticalResponse::API::Response.new client_class.get(
  client_class.uri_with_options(
    created_contact_response.url,
    { :type => 'all' }
  )
)
display_result('Contact with all details:', detailed_contact_response)

# 7. Create a general contact (without specifying a list)
# Here we are using the response wrapper object instead of the raw JSON response
created_contact_response = VerticalResponse::API::Response.new client_class.post(
  contacts_uri,
  client_class.build_params(
    { :email => "test_#{ Time.now.to_i }@verticalresponse.com" }
  )
)
display_result('Created general contact response:', created_contact_response)

# 8. Get all contacts for the user
# Here we are using the response wrapper object instead of the raw JSON response
contacts_response = VerticalResponse::API::Response.new client_class.get(
  contacts_uri
)
display_result('All contacts for the user:', contacts_response)

# 9. Create an email
created_email_raw_response = client_class.post(
  emails_uri,
  client_class.build_params(
    {
      :name => "Test email #{ Time.now.to_i }",
      :subject => 'Test subject',
      :message => 'Test message',
      :company => 'VerticalResponse',
      :street_address => '50 Beale St.',
      :locality => 'San Francisco',
      :region => 'California',
      :postal_code => '94105'
    }
  )
)
display_result('Created email response: (raw JSON)', created_email_raw_response)

# 10. Launch the email you just created
# Here we are using the response wrapper object instead of the raw JSON response
# Just the first 3 lists should be enough
lists = lists_response.items[0...3]
# But first make sure that we're not sending the "All Contacts" list,
# because that's not allowed
lists.delete_if { |list| list['attributes']['name'] == 'All Contacts' }
list_ids = lists.map { |list| list['attributes']['id'] }
email_launch_response = VerticalResponse::API::Response.new client_class.post(
  created_email_raw_response['url'],
  client_class.build_params({ 'list_ids' => list_ids })
)
display_result('Email launch response:', email_launch_response)

# 11. Get the summary stats for the email
# Here we are using the response wrapper object instead of the raw JSON response
email_stats_response = VerticalResponse::API::Response.new client_class.get(
  File.join(created_email_raw_response['url'], 'stats')
)
display_result('Summary stats for the email launched:', email_stats_response)

