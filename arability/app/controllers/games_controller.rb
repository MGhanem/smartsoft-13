class GamesController < ApplicationController
  def game
  end



  # Author:
  # 	Kareem Ali
  # Description:
  # 	displayes the vote form for the gamer
  # params:
  # 	word: takes a keyword name for which the synonym choices whill be displayed
  # success:
  # 	retrieve the approved synonym list limited to 4 only choosen randomly 
  # 	if the approved synonyms for the keyword is more than 4
  # failure:
  # 	--------- 
  def vote
  	name = params[:word]
  	word = Keyword.where(:name => name).first
  	retrieved_synonym_list = word.retrieve_synonyms()[0]
  	list_length = retrieved_synonym_list.length
  	while list_length > 4 do
        random_number = rand 0..list_length
        retrieved_synonym_list.delete_at(random_number)
        list_length = retrieved_synonym_list.length
    end
    @word = name
    @Keyword = word
    @synonym_list = retrieved_synonym_list

  end
  

  def record_vote
  end
end
