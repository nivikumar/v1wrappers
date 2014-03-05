# This is an example of how to use the VerticalResponse Ruby API wrapper
# for social posts-related actions.
#
# Before you run this example, you need to modify the following config file and
# include your access tokens for the user you have created in VerticalResponse:
#   ../config/api.yml
#
# The example consists of performing the following operations for the user:
#
# 1. Get all social posts (direct 'get' call)
# 2. Get all social posts (object oriented)
# 3. Get the full details of a social post (object oriented)
# 4. Get the summary stats for the social post (object oriented)
#
# As you can see, there are several ways to accomplish the same action. The idea
# behind this example is to show you some of them and let you make the decision
# about which one works best for your application.
#
# To run this example, simply execute this file with Ruby. e.g.
#   ruby examples/social_posts.rb

require 'pp'
require_relative '../lib/social_post'

def display_result(message, result)
  puts message
  pp result
  puts
  puts
end

# 1. Get all social posts (direct 'get' call)
social_posts_raw = VerticalResponse::API::SocialPost.get(
  VerticalResponse::API::SocialPost.uri_with_options(
    VerticalResponse::API::Message.resource_uri,
    { :message_type => 'social_post' }
  )
)
display_result('All social posts: (raw response)', social_posts_raw)

# 2. Get all social posts (object oriented)
# Check the Messages examples for some search options for the 'all' method
social_posts = VerticalResponse::API::SocialPost.all
display_result('All social posts:', social_posts)

if social_posts.any?
  social_post = social_posts.first

  # 3. Get the full details of a social post (object oriented)
  detailed_social_post = VerticalResponse::API::SocialPost.find(
    social_post.id,
    { :type => 'all' }
  )
  display_result('Social post with all details:', detailed_social_post)

  # 4. Get the summary stats for the social post (object oriented)
  stats = social_post.stats
  display_result('Summary stats for the social post:', stats)
end

