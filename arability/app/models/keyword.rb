class Keyword < ActiveRecord::Base
  attr_accessible :approved, :is_english, :name

# author:
# 	Omar Hossam
# description:
# 	feature takes no input and returns a list of all unapproved keywords
# success: 
# 	takes no arguments and returns to the admin a list containing the keywords 
# 	that are pending for approval in the database
# failure:
# 	returns an empty list if no words are pending for approval

  def self.listunapprovedkeywords

    return Keyword.where(approved: false).all

  end

end