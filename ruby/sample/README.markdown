Sample code
===========

The sample code here will be used in the tutorials that explain some of the core
operations. Also the sample code will be used in the API reference documentation
wherever it is appropriate.

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

Sample 2. Creating a List (POST request to *{{ API root }}/lists*)

  ```ruby
  require 'list'

  VerticalResponse::API::List.create(
    {
      :name => 'VIP List',
      :is_public => true
    }
  )
  ```

Sample 3. Adding a contact to a List (POST request to *{{ API root }}/lists/{{ list ID }}/contacts*)

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

Sample 4. Creating an email (POST request to *{{ API root }}/messages/emails*)

  ```ruby
  require 'email'

  VerticalResponse::API::Email.create(
    {
      :name => 'My new email campaign',
      :subject => 'Checkout my new product',
      :message => 'Look how awesome it is!',
      :company => 'VerticalResponse',
      :street_address => '50 Beale St.',
      :locality => 'San Francisco',
      :region => 'California',
      :postal_code => '94105'
    }
  )
  ```

Sample 5. Launching an email (POST request to *{{ API root }}/messages/emails/{{ email ID }}*)

  ```ruby
  require 'email'

  email = VerticalResponse::API::Email.find(<Email ID>)
  email.launch(
    {
      :list_ids => [ <List IDs to send email to> ]
    }
  )
  ```

Sample 6. Getting the summary stats for an email (GET request to *{{ API root }}/messages/emails/{{ email ID }}/stats*)

  ```ruby
  require 'email'

  email = VerticalResponse::API::Email.find(<Email ID>)
  email.summary_stats
  ```
