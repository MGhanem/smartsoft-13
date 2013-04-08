class Authentication < ActiveRecord::Base
  attr_accessible :gid, :gprovider, :token, :token_secret
end
