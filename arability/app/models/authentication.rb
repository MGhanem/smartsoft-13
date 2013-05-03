class Authentication < ActiveRecord::Base
  belongs_to :gamer
  attr_accessible :gid, :provider, :token, :token_secret, :email, :gamer_id

  # Author:
  #   Mirna Yacout
  # Description:
  #   This method is to create an authentication record for the current gamer
  # Parameters:
  #   provider: provider of the authentication (twitter/facebook/google)
  #   gid: gamer id in provided by the provider
  #   token: token provided for the gamer by the api
  #   token_secret: secret token provided for the gamer by the api
  #   email: email used to access the gamer's account for connection
  #   current_gamer: the record in Gamer table for the current user
  # Success:
  #   creates new record in Authentication table
  # Failure:
  #   none
  def self.create_with_omniauth(provider, gid, token, token_secret, email, current_gamer_id)
    authentication = Authentication.new(
      provider: provider,
      gid: gid,
      token: token,
      token_secret: token_secret,
      email: email,
      gamer_id: current_gamer_id
      )
    if authentication.save
      return authentication, true
    else
      return nil, false
    end
  end

  # Author:
  #   Mirna Yacout
  # Description:
  #   This method is to remove the authentication record for the current user
  # Parameters:
  #   current_gamer: the record in Gamer table for the current user
  #   provider: provider of the authentication (twitter/facebook/google)
  # Success:
  #   removes record for the current user in Authentication table
  # Failure:
  #   none
  def self.remove_conn(current_gamer_id, provider)
    authentication = Authentication.find_by_gamer_id_and_provider(current_gamer_id, provider)
    if (authentication.nil?)
      return
    end
    authentication.destroy
  end

  # Author:
  #   Mirna Yacout
  # Description:
  #   This method is to retrieve the list of common arability friends and Twitter friends
  # Parameters:
  #   current_gamer: the record in Gamer table for the current user
  # Success:
  #   returns the list of common friends
  # Failure:
  #   returns nil if no authentication is found
  def self.get_common_twitter_friends(current_gamer)
    begin
      auth = Authentication.find_by_gamer_id_and_provider(current_gamer.id,
       "twitter")
      if (auth.nil?)
        return nil
      end
      result = JSON.parse(open("https://api.twitter.com/1/friends/ids.json?user_id=#{auth.gid}").read)
      followers = Array.new(result["ids"])
      common = Array.new
      i = 0
      while i < followers.count
        if Authentication.exists?(gid: followers.at(i), provider: "twitter")
          common.push(Authentication.find_by_gid_and_provider(followers.at(i),
           "twitter").gamer_id)
        end
        i = i + 1
      end
      common.push(current_gamer.id)
      return common
    rescue SocketError
      return false
    rescue OpenURI::HTTPError 
      return false
    end
  end

  # Author:
  #   Mirna Yacout
  # Description:
  #   This method is to retrieve the list of common arability friends and Facebook friends
  # Parameters:
  #   current_gamer: the record in Gamer table for the current user
  # Success:
  #   returns the list of common followers
  # Failure:
  #   returns nil if no gamer token is found
  def self.get_common_facebook_friends(current_gamer)
    begin
      auth = Authentication.find_by_gamer_id_and_provider(current_gamer.id,
       "facebook")
      if auth.nil?
        return nil
      end
      @graph = Koala::Facebook::API.new(auth.token)
      friends = @graph.get_connections("me", "friends")
      common = Array.new
      i = 0
      while i < friends.count
        if Authentication.exists?(gid: friends.at(i)["id"], provider: "facebook")
          common.push(Authentication.find_by_gid_and_provider(friends.at(i)["id"],
           "facebook").gamer_id)
        end
        i = i + 1
      end
      common.push(current_gamer.id)
      return common
    rescue Faraday::Error::ConnectionFailed
      return false
    end
  end

  # Author
  #   Amr Abdelraouf
  # Description:
  #   Returns whether or not a gamer's account is connected to facebook
  # Params:
  #   id: the id of the gamer
  # Success:
  #   Boolean is returned to indicate whether the gamer is connected
  # Failure:
  #   None
  def self.is_connected_to_facebook(id)
    Authentication.exists?(gamer_id: id)
  end

  # Author:
  #   Amr Abdelraouf
  # Description:
  #   Returns the access token of a certain provider for a specified gamer
  # Params
  #   id: id of the gamer
  #   provider: name of the provider
  # Success:
  #   Returns the provider's access token for the gamer
  # Failure:
  #   None
  def self.get_token(id, provider)
    auth = Authentication.find_by_gamer_id_and_provider(id, provider)
    return auth.token
  end

  # Author:
  #   Amr Abdelraouf
  # Description:
  #   Updates access token (mostly when it expires)
  # Params:
  #   id: id of the gamer
  #   provider: provider that wants to update the token
  #   new_token: the new access token
  # Success:
  #   access token for provider is changed for a specified gamer
  # Failure:
  #   none
  def self.update_token(id, provider, new_token)
    auth = Authentication.find_by_gamer_id_and_provider(id, provider)
    auth.update_attribute(:token, new_token)
  end

end
