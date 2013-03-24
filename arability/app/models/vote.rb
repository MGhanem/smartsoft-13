class Vote < ActiveRecord::Base
  belongs_to :synonym
  belongs_to :gamer
  # attr_accessible :title, :body

   # This method is used to record the vote given for a certain synonym by a ceratin user
   # The input is the gamer_id which is the voter_id and the synonym_id that the gamer voted for
   # The method returns the created instance of model vote if the vote was correctly saved and
   # return nil otherwise.


  def self.recordVote (gamer_id, synonym_id)
       valid_gamer = gamer.find_by_id(gamer_id)
       valid_synonym = synonym.find_by_id(synonym_id)
       if valid_gamer!=nil && valid_synonym!=nil 
       @vote = Vote.new
       @vote.synonym_id = synonym_id
       @vote.gamer_id = 
       if @vote.save
       return @vote  
       else
       return nil
   	   end
   	   end
  end


end
