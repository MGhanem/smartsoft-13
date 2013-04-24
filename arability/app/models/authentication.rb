class Authentication < ActiveRecord::Base
  belongs_to :gamer
  attr_accessible :gid, :provider, :token, :token_secret, :email, :gamer_id

  # Author:
  #  Mirna Yacout
  # Description:
  #  This method is to create an authentication record for the current gamer
  # Parameters:
  #  auth: the hash received from Twitter API including all his Twitter information
  #  current_gamer: the record in Gamer table for the current user
  # Success:
  #  creates new record in Authentication table
  # Failure:
  #  none
  def self.create_with_omniauth(auth, current_gamer)
    create! do |authentication|
      authentication.provider = auth["provider"]
      authentication.gid = auth["uid"]
      authentication.token = auth["credentials"]["token"]
      authentication.token_secret = auth["credentials"]["secret"]
      authentication.gamer_id = current_gamer.id
    end
  end

  # Author:
  #  Mirna Yacout
  # Description:
  #  This method is to remove the authentication record for the current user
  # Parameters:
  #  current_gamer: the record in Gamer table for the current user
  # Success:
  #  removes record for the current user in Authentication table
  # Failure:
  #  none
  def self.remove_conn(current_gamer)
    authentication = Authentication.find_by_gamer_id_and_provider(current_gamer.id,
     "twitter")
    if (authentication.nil?)
      return
    end
    authentication.destroy
  end

  # Author:
  #  Mirna Yacout
  # Description:
  #  This method is to retrieve the list of common arability friends and Twitter followers
  # Parameters:
  #  current_gamer: the record in Gamer table for the current user
  # Success:
  #  returns the list of common followers
  # Failure:
  #  returns nil if no authentication is found
  def self.get_common_twitter_followers(current_gamer)
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
        common.push(current_gamer.id)
      end
      i = i + 1
      return common
    end
  end

  def self.create_with_omniauth_amr(gamer_id, provider, gid, email = nil, token = nil, token_secret = nil)
    authentication = Authentication.new(
      provider: provider,
      gid: gid,
      token: token,
      token_secret: token_secret,
      email: email,
      gamer_id: gamer_id
      )
    if authentication.save
      return authentication, true
    else
      return nil, false
    end
  end

end
