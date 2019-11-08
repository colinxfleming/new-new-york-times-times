require 'sinatra'

TWITTER_ACCT = 'newnyttimes'
TWITTER_URL = "https://www.twitter.com/#{TWITTER_ACCT}"

get '/' do
  redirect TWITTER_URL
end
