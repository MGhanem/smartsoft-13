class Keyword < ActiveRecord::Base
  	attr_accessible :approved, :is_english, :name

    # Description:
  	#  This method is to record the aproval of the admin to a certain keyword in the database
  	# Parameters:
  	#  id: the id of the keyword to be approved
  	# Success:
  	#  returns true on saving the approval correctly in the database
  	# Failure:
    #  returns false if the keyword doesnot exist in the database
    #  or if the approval failed to be saved in the database 
  	def self.approve_keyword(id)
	    if (Keyword.exists?(id))
        keyword = Keyword.find(id)
        keyword.approved = true
        return keyword.save
      end
      return false
	end
end
