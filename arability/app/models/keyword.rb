class Keyword < ActiveRecord::Base
  attr_accessible :approved, :is_english, :name
  has_many :synonyms
  
  # Author: Mostafa Hassaan
  # Description: Method gets the synonym of a certain word with the highest
  #               number of votes.
  # params: 
  #   word: a Keyword to get the highest voted synonym for
  # return:
  #   on succes: the highest voted Synonym of word gets returned. If two 
  #               synonyms have an equal number of votes, the first synonym 
  #               entered to the list is returned.
  #   on failure: if word has no synonyms, nothing is returned
  class << self
    def highest_voted_synonym(word)
      max_id = Synonym.where(:keyword_id => word.id).joins(:votes).count(:group => "synonym_id").max
      return Synonym.where(:id => max_id[0])
    end
  end

end
