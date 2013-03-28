class Keyword < ActiveRecord::Base
  attr_accessible :approved, :is_english, :name

  # Author:
  #  Mirna Yacout
  # Description:
  #  This method is to record the aproval of the admin to a certain keyword in the database
	# Parameters:
  #  id: the id of the keyword to be approved
	# Success:
  #  returns true on saving the approval correctly in the database
	# Failure:
  #  returns false if the keyword doesnot exist in the database
  #  or if the approval failed to be saved in the database 
  class << self
    def approve_keyword(kid)
      if (Keyword.exists?(id: kid))
        keyword = Keyword.find(kid)
        keyword.approved = true
        return keyword.save
      end
      return false
    end
  end
end