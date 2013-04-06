class Service < ActiveRecord::Base
  belongs_to :gamer
  attr_accessible :provider, :uid, :uname, :uemail
end