class Authentication < ActiveRecord::Base
  attr_accessible :gid, :provider, :token, :token_secret
  require 'open-uri'
  require 'json'

  class << self

    def common_twitter_followers(gid)
  	  result = JSON.parse("https://api.twitter.com/1/followers/ids.json?user_id=:gid&screen_name=twitterapi")
    end

  end

end
