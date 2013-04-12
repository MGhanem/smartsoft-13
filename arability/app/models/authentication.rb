class Authentication < ActiveRecord::Base
  belongs_to :gamer
  attr_accessible :gid, :provider, :token, :token_secret

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
    authentication.destroy
  end

end
