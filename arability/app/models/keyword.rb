class Keyword < ActiveRecord::Base
  	attr_accessible :approved, :is_english, :name

  	# This method is to record the aproval of the admin to a certain keyword
  	# Parameters:
  	#  id: the id of the keyword to be approved
  	# returns:
  	#  on success of recording the approval: true
  	#  on failure of recording the approval: false
  	def self.approve_keyword(id)
		keyword = Keyword.find(id)
		keyword.approved = true
	    return keyword.save
	end
end
