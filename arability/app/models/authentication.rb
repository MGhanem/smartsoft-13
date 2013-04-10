class Authentication < ActiveRecord::Base
  belongs_to :gamer
  attr_accessible :gid, :provider, :token, :token_secret
  
  class << self

  def create_with_omniauth(auth, current_gamer)
    create! do |authentication|
      authentication.provider = auth["provider"]
      authentication.gid = auth["uid"]
      authentication.token = auth['credentials']['token']
      authentication.token_secret = auth['credentials']['secret']
      authentication.gamer_id = current_gamer.id
    end
  end

  def remove_conn(current_gamer)
    authentication = Authentication.find_by_gamer_id_and_provider(current_gamer.id, "twitter")
    authentication.destroy
  end

  def get_common_twitter_followers(current_gamer)
    auth = Authentication.find_by_gamer_id_and_provider(current_gamer.id, "twitter")
    if (auth.nil?)
      return nil
    end
    result = JSON.parse(open("https://api.twitter.com/1/followers/ids.json?user_id=#{auth.gid}").read)
    followers = Array.new(result["ids"])
    common = Array.new
    i = 0
    while i<followers.count
      if Authentication.exists?(:gid => followers.at(i), :provider => "twitter")
        common.push(Authentication.find_by_gid_and_provider(followers.at(i), "twitter").gamer_id)
      end
      i = i + 1
      return common
    end
  end

  end
end
