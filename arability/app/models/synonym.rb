class Synonym < ActiveRecord::Base
  belongs_to :keywords
  attr_accessible :approved, :name
  has_many :votes

  # Author: Mostafa Hassaan
  # Description: Method returns the the number of votes of a certain synonym.
  # params:
  #   syn_id: ID of synonym to get the votes number for.
  # returns:
  #   on succes: return an int with number of votes of the synonym with syn_id
  #   on failure: --
  def self.getVotes(syn_id)
    return Vote.where("votes.synonym_id" => syn_id).count
  end




end
