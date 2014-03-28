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
# 2. Get the full details of the email you just created (direct 'get' call)
# 3. Get the full details of the email you just created (object oriented)
# 4. Update the email (object oriented)
# 5. Test launch the email you just created (object oriented)
# 6. Launch/schedule the email you just created (object oriented)
# 7. Get the summary stats for the email (object oriented)
# 8. Unschedule the email (object oriented)
# 9. Get all the lists the email is targetted to (object oriented)
# 10. Delete the email (object oriented)
# 11. Create another email (direct 'post' call)
# 12. Launch the email (direct 'post' call)
# 13. Get all emails (object oriented)
#
# As you can see, there are several ways to accomplish the same action. The idea
# behind this example is to show you some of them and let you make the decision
# about which one works best for your application.
#
# To run this example, simply execute this file with Ruby. e.g.
#   ruby examples/emails.rb

require 'pp'
require_relative '../lib/email'

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
  :postal_code => '94105',
  :from => 'test@verticalresponse.com',
  :from_label => 'test@verticalresponse.com',
  :reply_to => 'test@verticalresponse.com'
}
created_email = VerticalResponse::API::Email.create(
  email_create_params
)
display_result('Created email response:', created_email)

# 2. Get the full details of the email you just created (direct 'get' call)
detailed_email_raw = VerticalResponse::API::Email.get(
  VerticalResponse::API::Email.uri_with_options(
    created_email.url,
    { :type => 'all' }
  )
)
display_result('Email with all details: (raw response)', detailed_email_raw)

# 3. Get the full details of the email you just created (object oriented)
email = VerticalResponse::API::Email.find(created_email.id, { :type => 'all' })
display_result('Email created:', email)

# 4. Update the email (object oriented)
update_response = email.update({ :name => "Test email #{ Time.now.to_i } updated" })
display_result('Email update response:', update_response)

# 5. Test launch the email you just created (object oriented)
test_launch_result = email.test_launch(
  {
    :recipients => [
      "test1_#{ Time.now.to_i }@verticalresponse.com",
      "test2_#{ Time.now.to_i }@verticalresponse.com",
      "test3_#{ Time.now.to_i }@verticalresponse.com"
    ]
  }
)
display_result('Email test launch result:', test_launch_result)

# 6. Launch/schedule the email you just created (object oriented)

# Let's create the associated lists first
lists = []
# 2 lists should be enough for this example
2.times do |i|
  list = VerticalResponse::API::List.create(
    { :name => "Test list #{ i } #{ Time.now.to_i }" }
  )

  # Now add a contact to the list
  list.create_contact({ email: "test_#{ Time.now.to_i }@verticalresponse.com" })

  lists << list
end

# Now schedule the email to the lists we just created
schedule_result = email.launch(
  {
    :lists => lists,
    # Schedule 2 weeks from now
    :scheduled_at => (Time.now + 2*7*24*60*60).to_s
  }
)
display_result('Email schedule result:', schedule_result)

# 7. Get the summary stats for the email (object oriented)
stats = email.stats
display_result('Summary stats for the email launched:', stats)

# 8. Unschedule the email (object oriented)
unschedule_response = email.unschedule
display_result('Email unschedule response:', unschedule_response)

# 9. Get all the lists the email is targetted to (object oriented)
lists = email.lists
display_result('Lists the email is targetted to:', lists)

# 10. Delete the email (object oriented)
delete_response = email.delete
display_result('Email delete response:', delete_response)

# 11. Create another email (direct 'post' call)
created_email_raw = VerticalResponse::API::Email.post(
  VerticalResponse::API::Email.resource_uri,
  VerticalResponse::API::Email.build_params(
    email_create_params.merge({ :name => "Another email #{ Time.now.to_i }" })
  )
)
display_result('Created email: (raw response)', created_email_raw)

# 12. Launch the email (direct 'post' call)
email_id = VerticalResponse::API::Email.resource_id_from_url(created_email_raw['url'])
launch_raw = VerticalResponse::API::Email.post(
  VerticalResponse::API::Email.resource_uri(email_id),
  VerticalResponse::API::Email.build_params({ 'list_ids' => lists.map(&:id) })
)
display_result('Email launch result: (raw response)', launch_raw)

# 13. Get all emails (object oriented)
# Check the Messages examples for some search options for the 'all' method
emails = VerticalResponse::API::Email.all
display_result('All emails:', emails)

