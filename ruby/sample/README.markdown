Sample code
===========

The sample code here will be used in the tutorials that explain some of the core
operations. Also the sample code will be used in the API reference documentation
wherever it is appropriate.


## Contacts

Sample 1. Creating a contact (POST request to *{{ API root }}/contacts*)

  ```ruby
  require 'contact'

  VerticalResponse::API::Contact.create(
    {
      :email => 'test@verticalresponse.com',
      :first_name => 'John',
      :last_name => 'Doe'
    }
  )
  ```

  Sample 1.1 Creating a contact with custom fields (POST request to *{{ API root }}/contacts*)

  ```ruby
  require 'contact'

  VerticalResponse::API::Contact.create(
    {
      :email => 'test@verticalresponse.com',
      :first_name => 'John',
      :last_name => 'Doe',
      :custom => {
        'Pet name' => 'Rex',
        'Favorite Movie' => 'Jurassic Park'
      }
    }
  )
  ```

Sample 2. Updating a contact (PUT request to *{{ API root }}/contacts/{{ contact ID }}*)

  ```ruby
  require 'contact'

  contact = VerticalResponse::API::Contact.find(<Contact ID>)
  contact.update(
    {
      :first_name => 'Jane',
      :last_name => 'Roe',
      :custom => {
        'Favorite Movie' => 'Walking with Dinosaurs'
      }
    }
  )
  ```

Sample 3. Deleting a contact (DELETE request to *{{ API root }}/contacts/{{ contact ID }}*)

  ```ruby
  require 'contact'

  contact = VerticalResponse::API::Contact.find(<Contact ID>)
  contact.delete
  ```

Sample 4. Listing all contacts (GET request to *{{ API root }}/contacts*)

  ```ruby
  require 'contact'

  # Basic details
  VerticalResponse::API::Contact.all   # no params defaults to basic
  VerticalResponse::API::Contact.all({ :type => :basic })

  # Standard details (all standard fields)
  VerticalResponse::API::Contact.all({ :type => :standard })

  # All details (all standard fields + custom fields)
  VerticalResponse::API::Contact.all({ :type => :all })
  ```

Sample 5. Searching contacts (GET request to *{{ API root }}/contacts*)

  ```ruby
  require 'contact'

  # Search contacts by email address
  VerticalResponse::API::Contact.all({ :email_address => 'test@verticalresponse.com' })

  # Search contacts that were created after a specific date
  VerticalResponse::API::Contact.all({ :created_since => '2014-01-01' })

  # Search contacts that were created before a specific date
  VerticalResponse::API::Contact.all({ :created_until => '2014-12-31' })

  # Search contacts that were created within a specific date range
  VerticalResponse::API::Contact.all(
    {
      :created_since => '2014-01-01',
      :created_until => '2014-12-31'
    }
  )
  ```

Sample 6. Getting details of a contact (GET request to *{{ API root }}/contacts/{{ contact ID }}*)

  ```ruby
  require 'contact'

  # Basic details
  VerticalResponse::API::Contact.find(<Contact ID>)   # no params defaults to basic
  VerticalResponse::API::Contact.find(<Contact ID>, { :type => :basic })

  # Standard details (all standard fields)
  VerticalResponse::API::Contact.find(<Contact ID>, { :type => :standard })

  # All details (all standard fields + custom fields)
  VerticalResponse::API::Contact.find(<Contact ID>, { :type => :all })
  ```

Sample 7. Getting all the lists a contact is part of (GET request to *{{ API root }}/contacts/{{ contact ID }}/lists*)

  ```ruby
  require 'contact'

  contact = VerticalResponse::API::Contact.find(<Contact ID>)
  contact.lists
  ```

Sample 8. Getting all the messages targetted to a contact (GET request to *{{ API root }}/contacts/{{ contact ID }}/messages*)

  ```ruby
  require 'contact'

  contact = VerticalResponse::API::Contact.find(<Contact ID>)
  contact.messages
  ```

Sample 9. Getting all the contact field names (GET request to *{{ API root }}/contacts/fields*)

  ```ruby
  require 'contact'

  # Standard fields
  VerticalResponse::API::Contact.fields   # no params defaults to standard
  VerticalResponse::API::Contact.fields({ :type => :standard })

  # All fields (standard + custom fields)
  VerticalResponse::API::Contact.fields({ :type => :all })
  ```


## Lists

Sample 10. Creating a list (POST request to *{{ API root }}/lists*)

  ```ruby
  require 'list'

  VerticalResponse::API::List.create(
    {
      :name => 'VIP List',
      :is_public => true
    }
  )
  ```

Sample 11. Updating a list (PUT request to *{{ API root }}/lists/{{ list ID }}*)

  ```ruby
  require 'list'

  list = VerticalResponse::API::List.find(<List ID>)
  list.update(
    { :name => 'VIP List Updated' }
  )
  ```

Sample 12. Deleting a list (DELETE request to *{{ API root }}/lists/{{ list ID }}*)

  ```ruby
  require 'list'

  list = VerticalResponse::API::List.find(<List ID>)
  list.delete
  ```

Sample 13. Listing all lists (GET request to *{{ API root }}/lists*)

  ```ruby
  require 'list'

  # Basic details
  VerticalResponse::API::List.all   # no params defaults to basic
  VerticalResponse::API::List.all({ :type => :basic })

  # Standard details
  VerticalResponse::API::List.all({ :type => :standard })

  # All details
  VerticalResponse::API::List.all({ :type => :all })
  ```

Sample 14. Getting details of a list (GET request to *{{ API root }}/lists/{{ list ID }}*)

  ```ruby
  require 'list'

  # Basic details
  VerticalResponse::API::List.find(<List ID>)   # no params defaults to basic
  VerticalResponse::API::List.find(<List ID>, { :type => :basic })

  # Standard details
  VerticalResponse::API::List.find(<List ID>, { :type => :standard })

  # All details
  VerticalResponse::API::List.find(<List ID>, { :type => :all })
  ```

Sample 15. Adding a contact to a list (POST request to *{{ API root }}/lists/{{ list ID }}/contacts*)

  ```ruby
  require 'list'

  list = VerticalResponse::API::List.find(<List ID>)
  list.create_contact(
    {
      :email => 'test@verticalresponse.com',
      :first_name => 'John',
      :last_name => 'Doe',
      :custom => {
        'Pet name' => 'Rex',
        'Favorite Movie' => 'Jurassic Park'
      }
    }
  )
  ```

Sample 16. Removing a contact from a list (DELETE request to *{{ API root }}/lists/{{ list ID }}/contacts/{{ contact ID }}*)

  ```ruby
  require 'list'

  list = VerticalResponse::API::List.find(<List ID>)

  contact = VerticalResponse::API::Contact.find(<Contact ID>)
  list.delete_contact(contact)

  # Another way:
  contact = list.find_contact(<Contact ID>)
  contact.delete
  ```

Sample 17. Batch creating contacts in a list (POST request to *{{ API root }}/lists/{{ list ID }}/contacts*)

  ```ruby
  require 'list'

  list = VerticalResponse::API::List.find(<List ID>)
  list.create_contacts(
    [
      {
        :email => 'test1@verticalresponse.com',
        :first_name => 'John',
        :last_name => 'Doe',
        :custom => {
          'Pet name' => 'Rex',
          'Favorite Movie' => 'Jurassic Park'
        }
      },
      {
        :email => 'test2@verticalresponse.com',
        :first_name => 'John',
        :last_name => 'Doe',
        :custom => {
          'Pet name' => 'Dino',
          'Favorite Movie' => 'Jurassic Park 2'
        }
      },
      {
        :email => 'test3@verticalresponse.com',
        :first_name => 'John',
        :last_name => 'Doe',
        :custom => {
          'Pet name' => 'Triceratops',
          'Favorite Movie' => 'Jurassic Park 3'
        }
      }
    ]
  )
  ```

Sample 18. Batch deleting contacts from a list (DELETE request to *{{ API root }}/lists/{{ list ID }}/contacts*)

  ```ruby
  require 'list'

  list = VerticalResponse::API::List.find(<List ID>)
  list.delete_contacts(
    [
      { :email => 'test1@verticalresponse.com' },
      { :email => 'test2@verticalresponse.com' },
      { :email => 'test3@verticalresponse.com' }
    ]
  )
  ```

Sample 19. Find a contact in a list (DELETE request to *{{ API root }}/lists/{{ list ID }}/contacts/{{ contact ID }}*)

  ```ruby
  require 'list'

  list = VerticalResponse::API::List.find(<List ID>)

  # Basic details
  list.find_contact(<Contact ID>)   # no params defaults to basic
  list.find_contact(<Contact ID>, { :type => :basic })

  # Standard details
  list.find_contact(<Contact ID>, { :type => :standard })

  # All details
  list.find_contact(<Contact ID>, { :type => :all })
  ```

Sample 20. Getting all the messages targetted to a list (GET request to *{{ API root }}/lists/{{ list ID }}/messages*)

  ```ruby
  require 'list'

  list = VerticalResponse::API::List.find(<List ID>)
  list.messages
  ```


## Custom fields

Sample 21. Creating a custom field (POST request to *{{ API root }}/custom_fields*)

  ```ruby
  require 'custom_field'

  VerticalResponse::API::CustomField.create(
    { :name => 'Favorite Movie' }
  )
  ```

Sample 22. Updating a custom field (PUT request to *{{ API root }}/custom_fields/{{ custom field name }}*)

  ```ruby
  require 'custom_field'

  custom_field = VerticalResponse::API::CustomField.find(<Custom Field Name>)
  custom_field.update(
    { :name => 'Favorite Movie of All Times' }
  )
  ```

Sample 23. Deleting a custom field (DELETE request to *{{ API root }}/custom_fields/{{ custom field name }}*)

  ```ruby
  require 'custom_field'

  custom_field = VerticalResponse::API::CustomField.find(<Custom Field Name>)
  custom_field.delete
  ```

Sample 24. Listing all custom fields (GET request to *{{ API root }}/custom_fields*)

  ```ruby
  require 'custom_field'

  VerticalResponse::API::CustomField.all
  ```


## Messages

Sample 25. Listing all messages (GET request to *{{ API root }}/messages*)

  ```ruby
  require 'message'

  # Basic details
  VerticalResponse::API::Message.all   # no params defaults to basic
  VerticalResponse::API::Message.all({ :type => :basic })

  # All details
  VerticalResponse::API::Message.all({ :type => :all })
  ```

Sample 26. Searching messages (GET request to *{{ API root }}/messages*)

  ```ruby
  require 'message'

  # Search messages by status
  # e.g. get all draft messages:
  VerticalResponse::API::Message.all({ :status => 'draft' })

  # Search messages by message type
  # e.g. get all social posts:
  VerticalResponse::API::Message.all({ :message_type => 'social_post' })

  # Search messages that were created after a specific date
  VerticalResponse::API::Message.all({ :created_since => '2014-01-01' })

  # Search messages that were created before a specific date
  VerticalResponse::API::Message.all({ :created_until => '2014-12-31' })

  # Search messages that were created within a specific date range
  VerticalResponse::API::Message.all(
    {
      :created_since => '2014-01-01',
      :created_until => '2014-12-31'
    }
  )

  # Search messages that were scheduled after a specific date
  VerticalResponse::API::Message.all({ :scheduled_since => '2014-01-01' })

  # Search messages that were scheduled before a specific date
  VerticalResponse::API::Message.all({ :scheduled_until => '2014-12-31' })

  # Search messages that were scheduled within a specific date range
  VerticalResponse::API::Message.all(
    {
      :scheduled_since => '2014-01-01',
      :scheduled_until => '2014-12-31'
    }
  )

  # Search messages that were sent after a specific date
  VerticalResponse::API::Message.all({ :sent_since => '2014-01-01' })

  # Search messages that were sent before a specific date
  VerticalResponse::API::Message.all({ :sent_until => '2014-12-31' })

  # Search messages that were sent within a specific date range
  VerticalResponse::API::Message.all(
    {
      :sent_since => '2014-01-01',
      :sent_until => '2014-12-31'
    }
  )
  ```


## Emails

Sample 27. Creating an email (POST request to *{{ API root }}/messages/emails*)

  ```ruby
  require 'email'

  VerticalResponse::API::Email.create(
    {
      :name => 'My new email campaign',
      :subject => 'Check out my new product',
      :message => 'Look how awesome it is!',
      :company => 'VerticalResponse',
      :street_address => '50 Beale St.',
      :locality => 'San Francisco',
      :region => 'California',
      :postal_code => '94105'
    }
  )
  ```

Sample 28. Updating an email (PUT request to *{{ API root }}/messages/emails/{{ email ID }}*)

  ```ruby
  require 'email'

  email = VerticalResponse::API::Email.find(<Email ID>)
  email.update(
    { :name => 'Awesome product!' }
  )
  ```

Sample 29. Deleting an email (DELETE request to *{{ API root }}/messages/emails/{{ email ID }}*)

  ```ruby
  require 'email'

  email = VerticalResponse::API::Email.find(<Email ID>)
  email.delete
  ```

Sample 30. Listing all emails (GET request to *{{ API root}}/messages?message_type=email*)

  ```ruby
  require 'email'

  # Basic details
  VerticalResponse::API::Email.all   # no params defaults to basic
  VerticalResponse::API::Email.all({ :type => :basic })

  # All details
  VerticalResponse::API::Email.all({ :type => :all })
  ```

Sample 31. Searching emails (GET request to *{{ API root}}/messages?message_type=email*)

  ```ruby
  require 'email'

  # Search emails by status
  # e.g. get all draft emails:
  VerticalResponse::API::Email.all({ :status => 'draft' })

  # Search emails that were created after a specific date
  VerticalResponse::API::Email.all({ :created_since => '2014-01-01' })

  # Search emails that were created before a specific date
  VerticalResponse::API::Email.all({ :created_until => '2014-12-31' })

  # Search emails that were created within a specific date range
  VerticalResponse::API::Email.all(
    {
      :created_since => '2014-01-01',
      :created_until => '2014-12-31'
    }
  )

  # Search emails that were scheduled after a specific date
  VerticalResponse::API::Email.all({ :scheduled_since => '2014-01-01' })

  # Search emails that were scheduled before a specific date
  VerticalResponse::API::Email.all({ :scheduled_until => '2014-12-31' })

  # Search emails that were scheduled within a specific date range
  VerticalResponse::API::Email.all(
    {
      :scheduled_since => '2014-01-01',
      :scheduled_until => '2014-12-31'
    }
  )

  # Search emails that were sent after a specific date
  VerticalResponse::API::Email.all({ :sent_since => '2014-01-01' })

  # Search emails that were sent before a specific date
  VerticalResponse::API::Email.all({ :sent_until => '2014-12-31' })

  # Search emails that were sent within a specific date range
  VerticalResponse::API::Email.all(
    {
      :sent_since => '2014-01-01',
      :sent_until => '2014-12-31'
    }
  )
  ```

Sample 32. Getting details of an email (GET request to *{{ API root }}/messages/emails/{{ email ID }}*)

  ```ruby
  require 'email'

  # Basic details
  VerticalResponse::API::Email.find(<Email ID>)   # no params defaults to basic
  VerticalResponse::API::Email.find(<Email ID>, { :type => :basic })

  # Standard details
  VerticalResponse::API::Email.find(<Email ID>, { :type => :standard })

  # All details
  VerticalResponse::API::Email.find(<Email ID>, { :type => :all })
  ```

Sample 33. Launch Testing an email (POST request to *{{ API root }}/messages/emails/{{ email ID }}/test*)

  ```ruby
  require 'email'

  email = VerticalResponse::API::Email.find(<Email ID>)
  email.test_launch(
    {
      :recipients => [
        'test1@verticalresponse.com',
        'test2@verticalresponse.com',
        'test3@verticalresponse.com'
      ]
    }
  )
  ```

Sample 34. Launching an email (POST request to *{{ API root }}/messages/emails/{{ email ID }}*)

  ```ruby
  require 'email'

  email = VerticalResponse::API::Email.find(<Email ID>)
  # Send the email to the 2nd and 3rd lists (this is also show how pagination works)
  lists = VerticalResponse::API::List.all({ :index => 2, :limit => 2 })
  email.launch(
    { :lists => lists }
  )

  # You can also specify an array of list IDs directly
  email.launch(
    { :list_ids => [<2nd List ID>, <3rd List ID>] }
  )
  ```

Sample 35. Unscheduling an email (POST request to *{{ API root }}/messages/emails/{{ email ID }}/unschedule*)

  ```ruby
  require 'email'

  email = VerticalResponse::API::Email.find(<Email ID>)
  email.unschedule
  ```

Sample 36. Getting all the lists an email is targetted to (GET request to *{{ API root }}/messages/emails/{{ email ID }}/lists*)

  ```ruby
  require 'email'

  email = VerticalResponse::API::Email.find(<Email ID>)
  email.lists
  ```

Sample 37. Getting the summary stats for an email (GET request to *{{ API root }}/messages/emails/{{ email ID }}/stats*)

  ```ruby
  require 'email'

  email = VerticalResponse::API::Email.find(<Email ID>)
  email.stats
  ```


## Social Posts

Sample 38. Listing all social posts (GET request to *{{ API root}}/messages?message_type=social_post*)

  ```ruby
  require 'social_post'

  # Basic details
  VerticalResponse::API::SocialPost.all   # no params defaults to basic
  VerticalResponse::API::SocialPost.all({ :type => :basic })

  # All details
  VerticalResponse::API::SocialPost.all({ :type => :all })
  ```

Sample 39. Searching social posts (GET request to *{{ API root}}/messages?message_type=social_post*)

  ```ruby
  require 'social_post'

  # Search social posts by status
  # e.g. get all draft social posts:
  VerticalResponse::API::SocialPost.all({ :status => 'draft' })

  # Search social posts that were created after a specific date
  VerticalResponse::API::SocialPost.all({ :created_since => '2014-01-01' })

  # Search social posts that were created before a specific date
  VerticalResponse::API::SocialPost.all({ :created_until => '2014-12-31' })

  # Search social posts that were created within a specific date range
  VerticalResponse::API::SocialPost.all(
    {
      :created_since => '2014-01-01',
      :created_until => '2014-12-31'
    }
  )

  # Search social posts that were scheduled after a specific date
  VerticalResponse::API::SocialPost.all({ :scheduled_since => '2014-01-01' })

  # Search social posts that were scheduled before a specific date
  VerticalResponse::API::SocialPost.all({ :scheduled_until => '2014-12-31' })

  # Search social posts that were scheduled within a specific date range
  VerticalResponse::API::SocialPost.all(
    {
      :scheduled_since => '2014-01-01',
      :scheduled_until => '2014-12-31'
    }
  )

  # Search social posts that were sent after a specific date
  VerticalResponse::API::SocialPost.all({ :sent_since => '2014-01-01' })

  # Search social posts that were sent before a specific date
  VerticalResponse::API::SocialPost.all({ :sent_until => '2014-12-31' })

  # Search social posts that were sent within a specific date range
  VerticalResponse::API::SocialPost.all(
    {
      :sent_since => '2014-01-01',
      :sent_until => '2014-12-31'
    }
  )
  ```

Sample 40. Getting details of a social post (GET request to *{{ API root }}/messages/social_posts/{{ social post ID }}*)

  ```ruby
  require 'social_post'

  # Basic details
  VerticalResponse::API::SocialPost.find(<Social Post ID>)   # no params defaults to basic
  VerticalResponse::API::SocialPost.find(<Social Post ID>, { :type => :basic })

  # Standard details
  VerticalResponse::API::SocialPost.find(<Social Post ID>, { :type => :standard })

  # All details
  VerticalResponse::API::SocialPost.find(<Social Post ID>, { :type => :all })
  ```

Sample 41. Getting the summary stats for a social post (GET request to *{{ API root }}/messages/social_posts/{{ social post ID }}/stats*)

  ```ruby
  require 'social_post'

  social_post = VerticalResponse::API::SocialPost.find(<Social Post ID>)
  social_post.stats
  ```


## Authentication with OAuth

*See http://verticalresponse.mashery.com/docs/read/Authentication to
know more details about API authentication with OAuth.*

Sample 42. Authorizing a client ID that is already linked to an app (GET request to *{{ API root }}/oauth/authorize?client_id={{ client ID }}&redirect_uri={{ redirect URI }}*)

  ```ruby
  require 'oauth'

  VerticalResponse::API::OAuth.authorize(<Redirect URI>, <Client ID>)

  # This call will redirect you to a signin page, so you might want to render
  # the response if you're calling this from a controller.
  # For example, in Rails you can do something like:
  render :text => VerticalResponse::API::OAuth.authorize(<Redirect URI>, <Client ID>)
  ```

Sample 43. Getting the access token for a client ID that has already been authorized (GET request to *{{ API root }}/oauth/access_token?client_id={{ client ID }}&client_secret={{ client secret }}&code={{ auth code }}&redirect_uri={{ redirect URI }}*)

  ```ruby
  require 'oauth'

  # The response is a HTTParty::Response object that could contain either
  # JSON or HTML formatted text, so you should have code to handle the
  # response either way.
  VerticalResponse::API::OAuth.access_token(
    <Client Secret>, <Auth Code>, <Redirect URI>, <Client ID>
  )
  ```

