class Service < ActiveRecord::Base
	belongs_to :gamer
  attr_accessible :email, :provider, :uid, :uname, :user_id
end
