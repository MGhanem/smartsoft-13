class Synonym < ActiveRecord::Base
  belongs_to :keyword
  attr_accessible :approved, :name

# description:
#   feature adds synonym to database and returns a boolean result 
#   indicatiing success or failure of saving
# parameters:
#   syn: string input parameter that represents the synonym name
#   key_id: integer input parameter representing the keyword id
#     the synonym points to
#   approved: an optional boolean input parameter with a default false
# success:
#   Output is boolean -- this method returns true if the vote has been recorded.
# failure: 
#   returns false if word not saved to database due to incorrect expression of
#   synonym name or an incorrect keyword id for an unavaialable keyword in database

  validates_format_of :name, :with => /\A([\u0621-\u0625])\Z/i, :on => :create, :message => "The synonym is not in the correct form"

  def self.recordsynonym(syn, key_id, approved = false)
      if syn == ""
        return false
      else if Keyword.exists?(:id=>key_id)
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
