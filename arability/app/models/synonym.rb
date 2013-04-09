class Synonym < ActiveRecord::Base
  belongs_to :keyword
  attr_accessible :approved, :name, :keyword_id
  has_many :votes
  validates_format_of :name, :with => /^([\u0621-\u0652 ])+$/,
    :message => "The synonym is not in the correct form"

  class << self
    # Author:
    #  Mirna Yacout
    # Description:
    #  This method is to record the aproval of the admin to a certain synonym 
    #   in the database
    # Parameters:
    #  id: the id of the synonym to be approved
    # Success:
    #  returns true on saving the approval correctly in the database
    # Failure:
    #  returns false if the synonym doesnot exist in the database
    #  or if the approval failed to be saved in the database 
      def approve_synonym(synonym_id)
        if Synonym.exists?(id: synonym_id)
          synonym = Synonym.find(synonym_id)
          synonym.approved = true
          return synonym.save
        end
        return false
      end

    # author:
    #   Omar Hossam
    # description:
    #   feature adds synonym to database and returns a boolean result 
    #   indicatiing success or failure of saving
    # parameters:
    #   syn: string input parameter that represents the synonym name
    #   key_id: integer input parameter representing the keyword id
    #     the synonym points to
    #   approved: an optional boolean input parameter with a default false
    #     represents if an admin has approved a synonym on database or not
    # success:
    #   Output is boolean -- this method returns true if the vote has been 
    #   recorded.
    # failure: 
    #   returns false if word not saved to database due to incorrect expression 
    #   of synonym name or an incorrect keyword id for an unavaialable keyword 
    #   in database
      def recordsynonym(syn, key_id, approved = false)
        if syn == ""
          return false
        else if Keyword.exists?(id: key_id)
              synew = Synonym.new
              synew.name = syn
              synew.keyword_id = key_id 
              return synew.save
            else
              return false
            end
        end
      end
  end
end