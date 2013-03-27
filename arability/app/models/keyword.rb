class Keyword < ActiveRecord::Base
  attr_accessible :approved, :is_english, :name
  has_many :synonyms
  
  # Method gets the synonym of a certain word with the highest
  # number of votes.
  # params: 
  #   word: a Keyword to get the highest voted synonym for
  # return:
  #   on succes: the highest voted Synonym of word gets returned. If two synonyms have an 
  #               equal number of votes, the first synonym entered to the list is returned.
  #   on failure: if word has no synonyms, nothing is returned
  def self.highest_voted_synonym(word)
    syn = Synonym.where(:keyword_id => word.id).all
    highest = 0
    highest_syn =  nil
    syn.each do |s|
      if Synonym.getVotes(s.id) > highest
        highest_syn = s
        highest = Synonym.getVotes(s.id)
      end
    end
    return highest_syn
  end

end
