class Authentication < ActiveRecord::Base
  belongs_to :gamer
  attr_accessible :gid, :provider, :token, :token_secret
  
  class << self

  def create_with_omniauth(auth)
    create! do |authentication|
      authentication.provider = auth["provider"]
      authentication.gid = auth["gid"]
      authentication.token = auth["token"]
      authentication.token_secret = auth["token_secret"]
      authentication.gamer_id = current_gamer
    end
  end

  end
end