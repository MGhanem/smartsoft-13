class GamesController < ApplicationController
  def game
  end

  def vote
  end

  def record_vote
  	word=params[:word]
  	@keyword=Keyword..where(:name => word).first
  	@synonym_list=keyword.synonyms.limit(4)
  end
end
