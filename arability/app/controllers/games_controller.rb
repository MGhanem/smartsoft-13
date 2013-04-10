class GamesController < ApplicationController
  def game
  end

  def vote
  end

  def record_vote
  end

  # Description:
  #   After the gamer finishes a level this action is requested
  #   to award them with their prizes if they have any
  # Author:
  #   Adam Ghanem
  # @params:
  #   level: the level that the gamer finishes
  #   score: the score that the gamer earns
  # returns:
  #   success: lists out the prizes the gamer wins in a js erb view
  #   failure: the action is not even called
  def getprizes
    @level = params[:level].to_i
    @score = params[:score].to_i
    @won_prizes = Prize.get_new_prizes_for_gamer(current_gamer.id, 
                                                 @score, @level)
    @won_prizes.map { |wp| current_gamer.prizes << wp }
    respond_to do |format|
      format.js
    end
  end

  def record_synonym
  end

  # Description:
  #   After the gamer finishes a level this action is requested
  #   to award them with their trophies if they have any
  # Author:
  #   Adam Ghanem
  # @params:
  #   level: the level that the gamer finishes
  #   score: the score that the gamer earns
  # returns:
  #   success: lists out the trophies the gamer wins and a score in a rendered js erb view 
  #   failure: the doesn't win any trophies and only sees his score in a rendered js erb view
  def gettrophies
    @level = params[:level].to_i
    @score = params[:score].to_i
    @won_trophies = Trophy.get_new_trophies_for_gamer(current_gamer.id, 
                                                      @score, @level)
    @won_prizes = current_gamer.won_prizes?(@score, @level)
    @won_trophies.map { |nt| current_gamer.trophies << nt }
    respond_to do |format|
      format.js
    end
  end
  

  # Description:
  #   Returns the view that the gamer can view the prizes that 
  #   are available currently in the game and the prizes that they
  #   have already earned
  # Author:
  #   Adam Ghanem
  # @params:
  #   none
  # returns:
  #   success: renders out a view using js erb view with the 
  #   earned prizes in a list and the prizes that haven't been 
  #   earned in another
  def showprizes
    @won_prizes = current_gamer.get_won_prizes
    @not_won_prizes = current_gamer.get_available_prizes
    respond_to do |format|
      format.js
    end
  end
end
