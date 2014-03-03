# This is an example of how to use the VerticalResponse Ruby API wrapper
# for contacts-related actions.
#
# Before you run this example, you need to modify the following config file and
# include your access tokens for the user you have created in VerticalResponse:
#   ../config/api.yml
#
# The example consists of performing the following operations for the user:
#
# 1. Get all contacts (direct 'get' call)
# 2. Create a contact (object oriented)
# 3. Create a contact (direct 'post' call)
# 4. Get all contacts, including the 2 you just created (object oriented)
# 5. Get the full details of the last contact you created (object oriented)
# 6. Get the full details of the last contact (direct 'get' call)
# 7. Get all contacts using pagination (object oriented)
#
# As you can see, there are several ways to accomplish the same action. The idea
# behind this example is to show you some of them and let you make the decision
# about which one works best for your application.
#
# To run this example, simply execute this file with Ruby. e.g.
#   ruby examples/contacts.rb

require 'pp'
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'list'))

def display_result(message, result)
  puts message
  pp result
  puts
  puts
end

# 1. Get all contacts (direct 'get' call)
contacts_raw = VerticalResponse::API::Contact.get(
  VerticalResponse::API::Contact.resource_uri
)
display_result('All contacts: (raw response)', contacts_raw)

# 2. Create a contact (object oriented)
created_contact_response = VerticalResponse::API::Contact.create(
  { :email => "test_#{ Time.now.to_i }@verticalresponse.com" }
)
display_result('Created contact response:', created_contact_response)

# 3. Create a contact (direct 'post' call)
created_contact_raw = VerticalResponse::API::Contact.post(
  VerticalResponse::API::Contact.resource_uri,
  VerticalResponse::API::Contact.build_params(
    { :email => "test_raw_#{ Time.now.to_i }@verticalresponse.com" }
  )
)
display_result('Created contact response: (raw)', created_contact_raw)

# 4. Get all contacts, including the 2 you just created (object oriented)
contacts = VerticalResponse::API::Contact.all
display_result('All contacts:', contacts)

# 5. Get the full details of the last contact you created (object oriented)

# First, let's get the last contact object we created
contact_raw = VerticalResponse::API::Contact.get(created_contact_raw['url'])
contact = VerticalResponse::API::Contact.find(contact_raw['attributes']['id'])

# Now get the details
detailed_contact = contact.details({ :type => 'all' })
display_result('Contact with all details:', detailed_contact)

# 6. Get the full details of the last contact (direct 'get' call)
detailed_contact_raw = VerticalResponse::API::Contact.get(
  VerticalResponse::API::Contact.uri_with_options(
    VerticalResponse::API::Contact.resource_uri(contact.id),
    { :type => 'all' }
  )
)
display_result('Contact with all details: (raw response)', detailed_contact_raw)

# 7. Get all contacts using pagination - from contact 5 to 10 (object oriented)
paginated_contacts = VerticalResponse::API::Contact.all({ :index => 5, :limit => 5 })
display_result('All contacts with pagination:', paginated_contacts)

