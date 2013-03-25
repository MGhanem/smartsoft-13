class Synonym < ActiveRecord::Base
  belongs_to :keyword
  attr_accessible :approved, :name

  	# This method is to record the aproval of the admin to a certain synonym
  	# Parameters:
  	#  id: the id of the synonym to be approved
  	# returns:
  	#  on success of recording the approval: true
  	#  on failure of recording the approval: false
  	def self.approve_synonym(id)
		synonym = Synonym.find(id)
		synonym.approved = true
	    return synonym.save
	end
end
