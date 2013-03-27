class Synonym < ActiveRecord::Base
  belongs_to :keywords
  attr_accessible :approved, :name
  has_many :votes

  def getVotes(syn_id)
    return Synonym.joins(:votes).where("votes.synonym_id" => syn_id).count
  end




end
