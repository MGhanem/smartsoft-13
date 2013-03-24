class Keyword < ActiveRecord::Base
  attr_accessible :approved, :is_english, :name
  has_many :synonyms

  def self.words_with_unapproved_synonyms
  	return Keyword.joins(:synonyms).where("synonyms.approved" => false).all
  end
end
