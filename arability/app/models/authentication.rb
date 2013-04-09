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

  end
end