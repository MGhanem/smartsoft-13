class Vote < ActiveRecord::Base
  belongs_to :synonym
  belongs_to :gamer
  # attr_accessible :title, :body
  validate :validate_gamer_exists, :validate_synonym_exists, 
    :validate_voting_for_new_keyword
  validates :gamer_id, :uniqueness => { :scope => :synonym_id,
    :message => "This gamer has aleready voted for this synonym before" } 

  class << self
    #Author: Nourhan Zakaria
    #This method is used to record the vote given for a certain synonym 
    #by a certain gamer
    #Parameters:
    #  gamer_id: the voter(gamer) ID
    #  synonym_id: the synonym ID that the gamer voted for
    #Returns:
    #  On success: returns true and the instance of vote that 
    #  was created and saved
    #  On failure: returns false and the instance of vote that wasn't saved
    def record_vote(gamer_id, synonym_id) 
      vote = Vote.new
      vote.synonym_id = synonym_id
      vote.gamer_id = gamer_id
        if vote.save
          return true, vote  
        else
          return false, vote
        end
    end
  end

    #Author: Nourhan Zakaria
    #This is a custom validation method that validates that there exists 
    #a gamer with this gamer_id
    #Parameters: --
    #Returns: --
    def validate_gamer_exists
      valid_gamer = Gamer.find_by_id(gamer_id)
      if valid_gamer == nil
        errors.add(:gamer_id,"this gamer_id doesn't exist")
      end
    end

    #Author: Nourhan Zakaria
    #This is a custom validation method that validates that there exists 
    #a synonym with this synonym_id
    #Parameters: --
    #Returns: -- 
    def validate_synonym_exists
      valid_synonym = Synonym.find_by_id(synonym_id)
      if valid_synonym == nil
        errors.add(:synonym_id,"this synonym_id doesn't exist")
      end
    end

    #Author: Nourhan Zakaria
    #This is a custom validation method that validates that the synonym that 
    #the gamer is voting for doesn't belong to a keyword that 
    #this gamer voted for before
    #Parameters: --
    #Returns: --
    def validate_voting_for_new_keyword
      chosen_synonym = Synonym.where("id=?",synonym_id)
      if chosen_synonym != []
        k_id_of_chosen_synonym = chosen_synonym.first.keyword_id
        check = Keyword.where("id NOT IN( 
          SELECT K.id FROM Keywords K INNER JOIN Synonyms S ON 
          S.keyword_id = K.id AND S.id IN(SELECT S1.id FROM synonyms S1 
          INNER JOIN votes V ON S1.id = V.synonym_id INNER JOIN 
          gamers G ON G.id = V.gamer_id AND G.id = ?)) AND id = ?",
          gamer_id, k_id_of_chosen_synonym).exists?
        if !check 
          errors.add(:keyword_id,"this gamer voted for this keyword before")
        end
      end
    end
end
