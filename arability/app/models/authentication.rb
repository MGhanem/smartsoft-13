class Authentication < ActiveRecord::Base
  attr_accessible :gamer_id, :provider, :token, :token_secret, :uid
end
