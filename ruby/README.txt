Getting started
===============

The goal of this wrapper is to help you get started with the VR API.
The wrapper provides insights into connecting and making VR API calls.
You can extend this and create your own custom application.

The wrapper does not cover all the API calls VR provides. For a full list of
API calls VR provides, please refer to the documentation.

This software is provided "as-is", please note that VerticalResponse will not
maintain or update this.


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

1. Make Contact-related operations:
   - Create a contact
   - Get a list of all your contacts
   - Get the details of a particular contact

2. Make List-related operations:
   - Create a list
   - Get all of your lists
   - Get the details of a particular list
   - Create a contact in a particular list

3. Make Email-related operations:
   - Create an email
   - Look for an email based on its ID
   - Get the details of a particular email
   - Launch an existing email
   - Get the summary stats of a particular email

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

  - client.rb:    Provides examples on how to perform general operations.
  - emails.rb:    Provides examples on how to perform email-related operations.
  - lists.rb:     Provides examples on how to perform list-related operations.
  - contacts.rb:  Provides examples on how to perform contact-related operations.
  - errors.rb:    Provides examples on how to handle errors related to this wrapper.

You can find more details of each example inside those files.

