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
# 5. Get details of the list you created (object oriented)
# 6. Create a contact on the list (object oriented)
# 7. Get all contacts for the list (object oriented)
# 8. Get the full details of the contact you just created for the list (object oriented)
# 9. Get the full details of the contact (direct 'get' call)
# 10. Create another contact on the list (direct 'post' call)
# 11. Get all contacts for the list (direct 'get' call)
# 12. Remove a contact from the list (object oriented)
# 13. Batch create contacts in the list (object oriented)
# 14. Batch delete contacts from the list (object oriented)
# 15. Update the list (object oriented)
# 16. Get all the messages targetted to the list (object oriented)
# 17. Delete the list (object oriented)
#
# As you can see, there are several ways to accomplish the same action. The idea
# behind this example is to show you some of them and let you make the decision
# about which one works best for your application.
#
# To run this example, simply execute this file with Ruby. e.g.
#   ruby examples/lists.rb

require 'pp'
require_relative '../lib/list'

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
created_list = VerticalResponse::API::List.create(
  { :name => "Test list #{ Time.now.to_i }" }
)
display_result('Created list response:', created_list)

# 3. Get all lists, including the new one you just created (object oriented)
lists = VerticalResponse::API::List.all
display_result('All lists, including the new one:', lists)

# 4. Get all lists using pagination - from list 5 to 10 (object oriented)
paginated_lists = VerticalResponse::API::List.all({ :index => 5, :limit => 5 })
display_result('All lists with pagination:', paginated_lists)

# 5. Get details of the list you created (object oriented)
list = VerticalResponse::API::List.find(created_list.id)

# 6. Create a contact in the list (object oriented)
created_contact = list.create_contact(
  { :email => "test_#{ Time.now.to_i }@verticalresponse.com" }
)
display_result('Created contact response:', created_contact)

# 7. Get all contacts for the list (object oriented)
contacts = list.contacts
display_result('All contacts for the list:', contacts)

# 8. Get the full details of the contact you just created for the list (object oriented)
detailed_contact = list.find_contact(created_contact.id, { :type => 'all' })
display_result('Contact with all details:', detailed_contact)

# 9. Get the full details of the contact (direct 'get' call)
detailed_contact_raw = VerticalResponse::API::Contact.get(
  VerticalResponse::API::Contact.uri_with_options(
    VerticalResponse::API::List.resource_uri(list.id, 'contacts', created_contact.id),
    { :type => 'all' }
  )
)
display_result('Contact with all details: (raw response)', detailed_contact_raw)

# 10. Create another contact on the list (direct 'post' call)
created_contact_raw = VerticalResponse::API::Contact.post(
  VerticalResponse::API::List.resource_uri(list.id, 'contacts'),
  VerticalResponse::API::Contact.build_params(
    { :email => "test_raw_#{ Time.now.to_i }@verticalresponse.com" }
  )
)
display_result('Created contact response: (raw)', created_contact_raw)

# 11. Get all contacts for the list (direct 'get' call)
contacts_raw = VerticalResponse::API::Contact.get(
  VerticalResponse::API::List.resource_uri(list.id, 'contacts')
)
display_result('All contacts for the list: (raw response)', contacts_raw)

# 12. Remove a contact from the list (object oriented)
delete_response = list.delete_contact(detailed_contact)
display_result('Contact delete response:', delete_response)

contacts_data = [
  { :email => "test1_#{ Time.now.to_i }@verticalresponse.com" },
  { :email => "test2_#{ Time.now.to_i }@verticalresponse.com" },
  { :email => "test3_#{ Time.now.to_i }@verticalresponse.com" }
]

# 13. Batch create contacts in the list (object oriented)
batch_create_response = list.create_contacts(contacts_data)
display_result('Contacts batch create response:', batch_create_response)

# 14. Batch delete contacts from the list (object oriented)
batch_delete_response = list.delete_contacts(contacts_data)
display_result('Contacts batch delete response:', batch_delete_response)

# 15. Update the list (object oriented)
update_response = list.update({ :name => "Test list #{ Time.now.to_i } updated" })
display_result('Update response:', update_response)

# 16. Get all the messages targetted to the list (object oriented)
messages = list.messages
display_result('Messages targeted to the list:', messages)

# 17. Delete the list (object oriented)
delete_response = list.delete
display_result('Delete response:', delete_response)

