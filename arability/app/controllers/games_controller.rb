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
  # 	if the approved synonyms for the keyword is more than 4, keyword object and the keyword name
  #   
  # failure:
  # 	--------- 
  def vote
  	@word = params[:word]
  	@keyword = Keyword.where(:name => @word).first
  	@synonym_list = @keyword.retrieve_synonyms()[0]
  	list_length = @synonym_list.length
  	while list_length > 4 do
        random_number = rand 0..list_length - 1
        @synonym_list.delete_at(random_number)
        list_length = @synonym_list.length
    end
  end
  

  # Author:
  # 	Kareem Ali
  # Description:
  # 	makes the action of saving the vote for the gamer
  # params:
  # 	word: takes the synonym id for which the gamer voted for
  # success:
  # 	passes the synonym_id to the record_vote view
  # failure:
  #  	--------- 
  def record_vote
  	@synonym_id=params[:synonym_id]
  end

  # Author:
  # 	Kareem Ali
  # Description:
  # 	makes the action of saving the suggested synonym by the gamer
  # params:
  # 	synonym_name: takes the synonym name the gamer suggested
  # 	keyword_id:	takes the keyword id for the which the synonym is suggested
  # success:
  # 	returns 0 for record_output which means saved suggestion and
  # 	the already_existing_synonym whould be nill as the synonym is not existing
  #  	in the database 
  # failure:
  # 	returns 1 which means the the synonym_name is blank 
  # 	returns 2 for record_output is already existing and 
  # 	the second return variable would be the synonym object already existing.  
  def record_synonym
    @record_output = current_gamer.suggest_synonym(params[:synonym_name], params[:keyword_id]) 
  	@already_existing_synonym = Synonym.where(:name => params[:synonym_name],
      :keyword_id => params[:keyword_id]).first 
  end
  	
end