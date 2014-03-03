# This is an example of how to use the VerticalResponse Ruby API wrapper
# for lists-related actions.
#
# Before you run this example, you need to modify the following config file and
# include your access tokens for the user you have created in VerticalResponse:
#   ../config/api.yml
#
# The example consists of performing the following operations for the user:
#
# 1. Get all lists (direct 'get' call)
# 2. Create a list (object oriented)
# 3. Get all lists, including the new one you just created (object oriented)
# 4. Get all lists using pagination (object oriented)
# 5. Get the list you created (object oriented)
# 6. Create a contact on the list (object oriented)
# 7. Get all contacts for the list (object oriented)
# 8. Get the full details of the contact you just created (object oriented)
# 9. Get the full details of the contact (direct 'get' call)
# 10. Create another contact on the list (direct 'post' call)
# 11. Get all contacts for the list (direct 'get' call)
#
# As you can see, there are several ways to accomplish the same action. The idea
# behind this example is to show you some of them and let you make the decision
# about which one works best for your application.
#
# To run this example, simply execute this file with Ruby. e.g.
#   ruby examples/lists.rb

require 'pp'
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'list'))

def display_result(message, result)
  puts message
  pp result
  puts
  puts
end

# 1. Get all lists (direct 'get' call)
lists_raw = VerticalResponse::API::List.get(
  VerticalResponse::API::List.resource_uri
)
display_result('All lists: (raw response)', lists_raw)

# 2. Create a list (object oriented)
created_list_response = VerticalResponse::API::List.create(
  { :name => "Test list #{ Time.now.to_i }" }
)
display_result('Created list response:', created_list_response)

# 3. Get all lists, including the new one you just created (object oriented)
lists = VerticalResponse::API::List.all
display_result('All lists, including the new one:', lists)

# 4. Get all lists using pagination - from list 5 to 10 (object oriented)
paginated_lists = VerticalResponse::API::List.all({ :index => 5, :limit => 5 })
display_result('All lists with pagination:', paginated_lists)

# 5. Get the list you created (object oriented)
list_raw = VerticalResponse::API::List.get(created_list_response.url)
list = VerticalResponse::API::List.find(list_raw['attributes']['id'])

# 6. Create a contact on the list (object oriented)
created_contact_response = list.create_contact(
  { :email => "test_#{ Time.now.to_i }@verticalresponse.com" }
)
display_result('Created contact response:', created_contact_response)

# 7. Get all contacts for the list (object oriented)
contacts = list.contacts
display_result('All contacts for the list:', contacts)

# 8. Get the full details of the contact you just created (object oriented)

# First, let's get the contact object we just created
contact_raw = VerticalResponse::API::Contact.get(created_contact_response.url)
contact = VerticalResponse::API::Contact.find(contact_raw['attributes']['id'])

# Now get the details
detailed_contact = contact.details({ :type => 'all' })
display_result('Contact with all details:', detailed_contact)

# 9. Get the full details of the contact (direct 'get' call)
detailed_contact_raw = VerticalResponse::API::Contact.get(
  VerticalResponse::API::Contact.uri_with_options(
    VerticalResponse::API::Contact.resource_uri(contact.id),
    { :type => 'all' }
  )
)
display_result('Contact with all details: (raw response)', detailed_contact_raw)

# 10. Create another contact on the list (direct 'post' call)
contact_response_raw = VerticalResponse::API::Contact.post(
  VerticalResponse::API::List.contacts_uri(list.id),
  VerticalResponse::API::Contact.build_params(
    { :email => "test_raw_#{ Time.now.to_i }@verticalresponse.com" }
  )
)
display_result('Created contact response: (raw)', contact_response_raw)

# 11. Get all contacts for the list (direct 'get' call)
contacts_raw = VerticalResponse::API::Contact.get(
  VerticalResponse::API::List.contacts_uri(list.id)
)
display_result('All contacts for the list: (raw response)', contacts_raw)

