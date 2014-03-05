# This is an example of how to use the VerticalResponse Ruby API wrapper
# for messages-related actions.
#
# Before you run this example, you need to modify the following config file and
# include your access tokens for the user you have created in VerticalResponse:
#   ../config/api.yml
#
# The example consists of performing the following operations for the user:
#
# 1. Get all messages (direct 'get' call)
# 2. Get all messages (object oriented)
# 3. Search messages by status (object oriented)
# 4. Search messages by message type (object oriented)
# 5. Search messages by created date (object oriented)
# 6. Search messages by scheduled date (object oriented)
# 7. Search messages by sent date (object oriented)
#
# As you can see, there are several ways to accomplish the same action. The idea
# behind this example is to show you some of them and let you make the decision
# about which one works best for your application.
#
# To run this example, simply execute this file with Ruby. e.g.
#   ruby examples/messages.rb

require 'pp'
require_relative '../lib/message'

def display_result(message, result)
  puts message
  pp result
  puts
  puts
end

# 1. Get all messages (direct 'get' call)
messages_raw = VerticalResponse::API::Message.get(
  VerticalResponse::API::Message.resource_uri
)
display_result('All messages (raw response)', messages_raw)

# 2. Get all messages (object oriented)
messages = VerticalResponse::API::Message.all
display_result('All messages:', messages)

# 3. Search messages by status (object oriented)
messages = VerticalResponse::API::Message.all({ :status => 'draft' })
display_result('All messages by status: (all draft messages)', messages)

# 4. Search messages by message type (object oriented)
messages = VerticalResponse::API::Message.all({ :message_type => 'social_post' })
display_result('All messages by message type: (all social posts)', messages)

# 5. Search messages by created date (object oriented)
messages = VerticalResponse::API::Message.all({ :created_since => "#{ Date.today.year }-01-01" })
display_result('All messages by created date: (all messages created since the beginning of the year)', messages)

messages = VerticalResponse::API::Message.all({ :created_until => "#{ Date.today.year }-12-31" })
display_result('All messages by created date: (all messages created before end of year)', messages)

messages = VerticalResponse::API::Message.all(
  {
    :created_since => "#{ Date.today.year }-01-01",
    :created_until => "#{ Date.today.year }-12-31"
  }
)
display_result('All messages by created date: (all messages created within this year)', messages)

# 6. Search messages by scheduled date (object oriented)
messages = VerticalResponse::API::Message.all({ :scheduled_since => "#{ Date.today.year }-01-01" })
display_result('All messages by scheduled date: (all messages scheduled since the beginning of the year)', messages)

messages = VerticalResponse::API::Message.all({ :scheduled_until => "#{ Date.today.year }-12-31" })
display_result('All messages by scheduled date: (all messages scheduled before end of year)', messages)

messages = VerticalResponse::API::Message.all(
  {
    :scheduled_since => "#{ Date.today.year }-01-01",
    :scheduled_until => "#{ Date.today.year }-12-31"
  }
)
display_result('All messages by scheduled date: (all messages scheduled within this year)', messages)

# 7. Search messages by sent date (object oriented)
messages = VerticalResponse::API::Message.all({ :sent_since => "#{ Date.today.year }-01-01" })
display_result('All messages by sent date: (all messages sent since the beginning of the year)', messages)

messages = VerticalResponse::API::Message.all({ :sent_until => "#{ Date.today.year }-12-31" })
display_result('All messages by sent date: (all messages sent before end of year)', messages)

messages = VerticalResponse::API::Message.all(
  {
    :sent_since => "#{ Date.today.year }-01-01",
    :sent_until => "#{ Date.today.year }-12-31"
  }
)
display_result('All messages by sent date: (all messages sent within this year)', messages)

