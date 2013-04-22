class Gamers_Trophy < ActiveRecord::Base
	has_and_belongs_to_many :gamers
	attr_accessible :gamer_id, :trophy_id
end