class Vote < ActiveRecord::Base
  belongs_to :synonym
  belongs_to :gamer

  validate :validate_gamer_exists, :validate_synonym_exists, 
    :validate_voting_for_new_keyword
  validates :gamer_id, :uniqueness => { :scope => :synonym_id,
    :message => "This gamer has aleready voted for this synonym before" } 

  @@ENG = 0
  @@ARABIC = 1
  @@BOTH = 2

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

    #Author: Nourhan Zakaria
    #This method is used to get a list of specific size of keywords 
    #that gamer with this gamer_id didn't vote on yet.
    #Parameters:
    #  gamer_id: the gamer ID 
    #  count: the size of the list to be retreived
    #  lang: integer to specify the language of keywords to be retreived  
    #  if 0 then english only, if 1 then arabic only, 
    #  otherwise both english and arabic keywords can be icluded
    #Returns:
    #  On success: Returns a list of un voted keywords of the specified langauge 
    #  with size = count for the gamer with this gamer_id  
    #  On failure: Returns empty list
    def get_unvoted_keywords(gamer_id, count, lang)
      unvoted_keywords = Keyword.where("id NOT IN(
        SELECT K.id FROM Keywords K INNER JOIN Synonyms S ON S.keyword_id = 
        K.id AND S.id IN (SELECT S1.id FROM synonyms S1 INNER JOIN votes V 
        ON S1.id = V.synonym_id INNER JOIN gamers G ON G.id = V.gamer_id 
        AND G.id = ?)) OR id NOT IN(SELECT K1.id FROM Keywords K1 INNER JOIN 
        Synonyms S1 ON S1.keyword_id = K1.id)", gamer_id)                            
      if lang == @@ENG    
        keywords_list = unvoted_keywords.where('is_english=?', true)
      elsif lang == @@ARABIC
        keywords_list = unvoted_keywords.where('is_english=?', false)
      else
        keywords_list = unvoted_keywords
      end
      return keywords_list.sample(count)    
    end

    #Author: Nourhan Zakaria
    #Returns the value of constant representing English language
    #Parameters: --
    #Returns:
    #  On success: returns @@ENG
    #  On failure: --
    def get_lang_english
      return @@ENG
    end

    #Author: Nourhan Zakaria
    #Returns the value of constant representing Arabic language
    #Parameters: --
    #Returns:
    #  On success: returns @@ARABIC
    #  On failure: --
    def get_lang_arabic
      return @@ARABIC
    end

    #Author: Nourhan Zakaria
    #Returns the value of constant representing both language
    #Parameters: --
    #Returns:
    #  On success: returns @@BOTH
    #  On failure: --
    def get_lang_both
      return @@BOTH
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
    if !chosen_synonym.blank?
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

  
