# This is an example of how to use the VerticalResponse Ruby API wrapper
# for emails-related actions.
#
# Before you run this example, you need to modify the following config file and
# include your access tokens for the user you have created in VerticalResponse:
#   ../config/api.yml
#
# The example consists of performing the following operations for the user:
#
# 1. Create an email (object oriented)
# 2. Get the full details of the email you just created (object oriented)
# 3. Get the email you just created (object oriented)
# 4. Launch the email you just created (object oriented)
# 5. Get the summary stats for the email (object oriented)
# 6. Create another email (direct 'post' call)
# 7. Launch the email (direct 'post' call)
#
# As you can see, there are several ways to accomplish the same action. The idea
# behind this example is to show you some of them and let you make the decision
# about which one works best for your application.
#
# To run this example, simply execute this file with Ruby. e.g.
#   ruby examples/emails.rb

require 'pp'
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'email'))

def display_result(message, result)
  puts message
  pp result
  puts
  puts
end

# 1. Create an email (object oriented)
email_create_params = {
  :name => "Test email #{ Time.now.to_i }",
  :subject => 'Test subject',
  :message => 'Test message',
  :company => 'VerticalResponse',
  :street_address => '50 Beale St.',
  :locality => 'San Francisco',
  :region => 'California',
  :postal_code => '94105'
}
email_response = VerticalResponse::API::Email.create(
  email_create_params
)
display_result('Created email response:', email_response)

# 2. Get the full details of the email you just created (direct 'get' call)
detailed_email_raw = VerticalResponse::API::Email.get(
  VerticalResponse::API::Email.uri_with_options(
    email_response.url,
    { :type => 'all' }
  )
)
display_result('Email with all details: (raw response)', detailed_email_raw)

# 3. Get the email you just created (object oriented)
email = VerticalResponse::API::Email.find(detailed_email_raw['attributes']['id'])
display_result('Email created:', email)

# 4. Launch the email you just created (object oriented)

# Let's create the associated lists first
lists = []
# 2 lists should be enough for this example
2.times do |i|
  create_list_response = VerticalResponse::API::List.create(
    { :name => "Test list #{ i } #{ Time.now.to_i }" }
  )

  # Now get the list object and add a contact to the list
  list_id = VerticalResponse::API::List.get(create_list_response.url)['attributes']['id']
  list = VerticalResponse::API::List.find(list_id)
  list.create_contact({ email: "test_#{ Time.now.to_i }@verticalresponse.com" })

  lists << list
end

# Now launch the email sending the list IDs
launch_params = { 'list_ids' => lists.map(&:id) }
launch_result = email.launch(launch_params)
display_result('Email launch result:', launch_result)

# 5. Get the summary stats for the email (object oriented)
stats = email.summary_stats
display_result('Summary stats for the email launched:', stats)

# 6. Create another email (direct 'post' call)
email_raw = VerticalResponse::API::Email.post(
  VerticalResponse::API::Email.resource_uri,
  VerticalResponse::API::Email.build_params(
    email_create_params.merge({ :name => "Another email #{ Time.now.to_i }" })
  )
)
display_result('Created email: (raw response)', email_raw)

# 7. Launch the email (direct 'post' call)
email_id = VerticalResponse::API::Email.get(email_raw['url'])['attributes']['id']
launch_raw = VerticalResponse::API::Email.post(
  VerticalResponse::API::Email.resource_uri(email_id),
  VerticalResponse::API::Email.build_params(launch_params)
)
display_result('Email launch result: (raw response)', launch_raw)

