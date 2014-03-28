Getting started
===============

The goal of this wrapper is to help you get started with the VR API.
The wrapper provides insights into connecting and making VR API calls.
You can extend this and create your own custom application.

The wrapper does not cover all the API calls VR provides. For a full list of
API calls VR provides, please refer to the documentation.

This software is provided "as-is", please note that VerticalResponse will not
maintain or update this.

See http://developer.verticalresponse.com/docs to know more details about
the VR API.


Dependencies
------------

This wrapper has been written and tested using Ruby 2.0. However, it was
written with older versions of Ruby in mind (without any version-specific
syntax.)

In order to use this wrapper, you need to have the Httparty Gem installed
in your system (http://rubygems.org/gems/httparty) This wrapper has been
written using version 0.11.0 of that Gem, it hasn't been tested with other
versions.


Features
========

This wrapper allows you to:

1. Authenticate with the API using OAuth:
   - Authorize a client ID that is already linked to an app
   - Get the access token for a client ID that has already been authorized

2. Make Contact-related operations:
   - Create a contact
   - Update a contact
   - Delete a contact
   - Get a list of all your contacts
   - Find contacts by several search criteria
   - Get the details of a particular contact
   - Get all the lists a contact is part of
   - Get all the messages targetted to a contact
   - Get all the contact field names

3. Make List-related operations:
   - Create a list
   - Update a list
   - Delete a list
   - Get all of your lists
   - Get the details of a particular list
   - Create a contact in a particular list
   - Remove a contact from a particular list
   - Batch create contacts in a particular list
   - Batch remove contacts from a particular list
   - Find a contact in a list
   - Get all the messages targetted to a list

4. Make Custom field-related operations:
   - Create a custom field
   - Update a custom field
   - Delete a custom field
   - Get a list of all your custom fields

5. Make messages-related operations:
   - Get a list of all your messages
   - Find messages by several search criteria

6. Make Email-related operations:
   - Create an email
   - Update an email
   - Delete an email
   - Get the details of a particular email
   - Perform a launch test for an existing email
   - Launch/schedule an existing email
   - Unschedule a previously scheduled email
   - Get all the lists an email is targetted to
   - Get the summary stats of a particular email

7. Make Social post-related operations:
   - Get the details of a particular social post
   - Get the summary stats of a particular social post

All of these can be done in an object oriented way, or by making direct REST
calls to the API through the Client class.


Configuration
=============

In order to use the methods in this wrapper, you'll need to set your credentials.
To do so, edit the configuration file located in "config/api.yml" and change the
client ID and access token before running the application.

After that, you will be able to use all of the methods in this wrapper.


Examples
========

An "examples" folder is provided in order to give you guidance about how to use
this wrapper. In this folder you will find the following files:

  - client.rb:        Provides examples on how to perform general operations.
  - lists.rb:         Provides examples on how to perform list-related operations.
  - contacts.rb:      Provides examples on how to perform contact-related operations.
  - custom_fields.rb: Provides examples on how to perform custom field-related operations.
  - messages.rb:      Provides examples on how to perform messages-related operations.
  - emails.rb:        Provides examples on how to perform email-related operations.
  - social_posts.rb:  Provides examples on how to perform social post-related operations.
  - errors.rb:        Provides examples on how to handle errors related to this wrapper.

You can find more details of each example inside those files.

