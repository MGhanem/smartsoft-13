class Keyword < ActiveRecord::Base
  attr_accessible :approved, :is_english, :name
  has_many :synonyms

  # Method takes no inputs and returns an array of "Keywords"
  # with "synonyms" that haven't been approved yet.
  # params: none
  # returns:
  #   on success: Array of "keywords"
  #   on failure: Empty array
  def self.words_with_unapproved_synonyms
  	return Keyword.joins(:synonyms).where("synonyms.approved" => false).all
  end

end
