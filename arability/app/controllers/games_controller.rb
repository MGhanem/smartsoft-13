class GamesController < ApplicationController
  def game
  end

  def vote
  end

  def record_vote

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

  # Description:
  #   Returns the view that the gamer can view the trophies that 
  #   are available currently in the game and the trophies that they
  #   have already earned
  # Author:
  #   Adam Ghanem
  # @params:
  #   none
  # returns:
  #   success: renders out a view using js erb view with the 
  #   earned trophies in a list and the trophies that haven't been 
  #   earned in another
  def showtrophies
    @won_trophies = current_gamer.get_won_trophies
    @not_won_trophies = current_gamer.get_available_trophies
    respond_to do |format|
      format.js
    end
  end
end
