# This is an example of how to use the VerticalResponse Ruby API wrapper
# for custom fields-related actions.
#
# Before you run this example, you need to modify the following config file and
# include your access tokens for the user you have created in VerticalResponse:
#   ../config/api.yml
#
# The example consists of performing the following operations for the user:
#
# 1. Get all custom fields (direct 'get' call)
# 2. Create a custom field (object oriented)
# 3. Create a custom field (direct 'post' call)
# 4. Get all custom fields, including the 2 you just created (object oriented)
# 5. Update a custom field (object oriented)
# 6. Delete a custom field (object oriented)
#
# As you can see, there are several ways to accomplish the same action. The idea
# behind this example is to show you some of them and let you make the decision
# about which one works best for your application.
#
# To run this example, simply execute this file with Ruby. e.g.
#   ruby examples/custom_fields.rb

require 'pp'
require_relative '../lib/custom_field'

def display_result(message, result)
  puts message
  pp result
  puts
  puts
end

# 1. Get all custom fields (direct 'get' call)
custom_fields_raw = VerticalResponse::API::CustomField.get(
  VerticalResponse::API::CustomField.resource_uri
)
display_result('All custom fields: (raw response)', custom_fields_raw)

# 2. Create a custom field (object oriented)
custom_field = VerticalResponse::API::CustomField.create(
  { :name => "Custom Field #{ Time.now.to_i }" }
)
display_result('Created custom field response:', custom_field)

# 3. Create a custom field (direct 'post' call)
created_custom_field_raw = VerticalResponse::API::CustomField.post(
  VerticalResponse::API::CustomField.resource_uri,
  VerticalResponse::API::CustomField.build_params(
    { :name => "Custom Field #{ Time.now.to_i } raw" }
  )
)
display_result('Created custom field response: (raw)', created_custom_field_raw)

# 4. Get all custom fields, including the 2 you just created (object oriented)
custom_fields = VerticalResponse::API::CustomField.all
display_result('All custom fields:', custom_fields)

# 5. Update a custom field (object oriented)
updated_custom_field = custom_field.update(
  { :name => "Custom Field #{ Time.now.to_i } updated" }
)
display_result('Update custom field response:', updated_custom_field)

# 6. Delete a custom field (object oriented)
delete_response = updated_custom_field.delete
display_result('Delete custom field response:', delete_response)

