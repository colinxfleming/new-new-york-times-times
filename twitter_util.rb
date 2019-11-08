require 'twitter'
require 'dotenv'

TIMES_TIMES_ACCOUNT = 'newnyttimes'
TIMES_ACCOUNT = 'NYT_first_said'

def post_to_twitter
  client = init_twitter
  last_post = last_post_time client
  eligible_tweets = nyt_first_said_tl client, last_post
  post client, eligible_tweets
end
  
def init_twitter
  Dotenv.load if ENV['APP_ENV'] != :production

  client = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV['CONSUMER_KEY']
    config.consumer_secret     = ENV['CONSUMER_SECRET']
    config.access_token        = ENV['ACCESS_TOKEN']
    config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
  end
  client
end

def last_post_time(client)
  # Get last post made for a time to check against
  client.user_timeline(TIMES_TIMES_ACCOUNT, count: 1)
    .first
    .created_at
end

def nyt_first_said_tl(client, since)
  # return posts since the last time newnyttimes posted
  # TODO slim this down on query
  client.user_timeline(TIMES_ACCOUNT, count: 1) # for now, count 1
    .reject { |tweet| tweet.created_at > since }
    .map { |tweet| tweet.created_at.to_s }
end

def post(client, eligible_tweets)
  # TODO figure out how to psot as another person
  eligible_tweets.each { |x| client.update x }
  # client.update('HI')
end
