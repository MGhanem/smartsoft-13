class Vote < ActiveRecord::Base
  belongs_to :synonym
  belongs_to :gamer
  # attr_accessible :title, :body
 
   # Author: Nourhan Zakaria
   # This method is used to get a list of specific size of keywords 
   # that gamer with this gamer_id didn't vote on yet.
   # Parameters:
   #  gamer_id: the gamer ID 
   #  count: the size of the list to be retreived
   #  lang: integer to specify the language of keywords to be retreived  
   #  if 0 then english only, if 1 then arabic only, 
   #  otherwise both english and arabic keywords can be icluded
   # Returns:
   #  On success: Returns a list of un voted keywords of the specified langauge 
   #  with size = count for the gamer with this gamer_id  
   #  On failure: Returns empty list 
class << self
  def get_unvoted_keywords(gamer_id, count, lang)
      unvoted_keywords = Keyword.where( "id Not IN(
                                        Select K.id from Keywords K 
                                        INNER JOIN Synonyms  S ON 
                                        S.keyword_id = K.id AND S.id IN (
                                        SELECT S1.id FROM synonyms S1 
                                        INNER JOIN votes V on S1.id = 
                                        V.synonym_id 
                                        INNER JOIN gamers G on G.id = 
                                        V.gamer_id AND G.id = ?)) 
                                        OR id NOT IN( Select K1.id from 
                                        Keywords K1 INNER JOIN Synonyms S1
                                        ON S1.keyword_id = K1.id)", gamer_id)                            
          if lang == 0    
            keywords_list = unvoted_keywords.where('is_english=?', true)
          elsif lang == 1
            keywords_list = unvoted_keywords.where('is_english=?', false)
          else
            keywords_list = unvoted_keywords
          end
      return keywords_list.sample(count)    
  end
end
end

  
