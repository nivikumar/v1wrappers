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
# 8. Update a contact (object oriented)
# 9. Get all the lists a contact is part of (object oriented)
# 10. Get all the messages targetted to a contact (object oriented)
# 11. Delete a contact (object oriented)
# 12. Get all the contact fields available (object oriented)
#
# As you can see, there are several ways to accomplish the same action. The idea
# behind this example is to show you some of them and let you make the decision
# about which one works best for your application.
#
# To run this example, simply execute this file with Ruby. e.g.
#   ruby examples/contacts.rb

require 'pp'
require_relative '../lib/contact'

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
created_contact = VerticalResponse::API::Contact.create(
  { :email => "test_#{ Time.now.to_i }@verticalresponse.com" }
)
display_result('Created contact response:', created_contact)

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
contact = VerticalResponse::API::Contact.find(created_contact.id, { :type => 'all' })
display_result('Contact with all details:', contact)

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

# 8. Update a contact (object oriented)
update_response = contact.update({ :first_name => 'Jane', :last_name => 'Roe' })
display_result('Update contact response:', update_response)

# 9. Get all the lists a contact is part of (object oriented)
lists = contact.lists
display_result('Lists the contact is part of:', lists)

# 10. Get all the messages targetted to a contact (object oriented)
messages = contact.messages
display_result('Messages targeted to the contact:', messages)

# 11. Delete a contact (object oriented)
delete_response = contact.delete
display_result('Delete contact response:', delete_response)

# 12. Get all the contact fields available (object oriented)
fields = VerticalResponse::API::Contact.fields({ :type => :all })
display_result('Contact fields available:', fields)

