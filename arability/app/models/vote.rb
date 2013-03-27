class Vote < ActiveRecord::Base
  belongs_to :synonym
  belongs_to :gamer
  attr_accessible :title, :body, :id
  #validates_uniqueness_of :gamer_id, :scope => :synonym_id
  #validates_existence_of :gamer_id
  #validates_existence_of :synonym_id


   # This method is used to record the vote given for a certain synonym by a ceratin user
   # Parameters:
   #  gamer_id: the voter ID
   #  synonym_id: the synonym_id that the gamer voted for
   # Returns:
   #  On success: Returns the instance of vote that was created and saved
   #  On failure: returns nil
  def self.recordVote (gamer_id, synonym_id)
       valid_gamer = Gamer.find_by_id(gamer_id)
       valid_synonym = Synonym.find_by_id(synonym_id)
        if valid_gamer!=nil && valid_synonym!=nil 
          @vote = Vote.new
          @vote.synonym_id = synonym_id
          @vote.gamer_id = gamer_id
            if @vote.save
              return @vote  
            else
              return nil
   	        end
   	    end
  end




end
