class Authentication < ActiveRecord::Base
  attr_accessible :gid, :provider, :token, :token_secret
end
