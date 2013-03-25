class Keyword < ActiveRecord::Base
  	attr_accessible :approved, :is_english, :name
  	def self.approveKeyword(id)
		@keyword = Keyword.find(id)
		@keyword.update_attribute(:approved,true)
	end
end
