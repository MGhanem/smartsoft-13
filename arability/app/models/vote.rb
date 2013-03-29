class Vote < ActiveRecord::Base
  belongs_to :synonym
  belongs_to :gamer
  # attr_accessible :title, :body
  @@ENG = 0
  @@ARABIC = 1
  
  class << self
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
    #  On success: returns 0
    #  On failure: --
    def get_lang_english
      return 0
    end

    #Author: Nourhan Zakaria
    #Returns the value of constant representing Arabic language
    #Parameters: --
    #Returns:
    #  On success: returns 1
    #  On failure: --
    def get_lang_arabic
      return 1
    end
  end
end

  
