class GamesController < ApplicationController
  def game
  end

  def vote
  end

  def record_vote

  end
  


  def showprizes
    @won_prizes = current_gamer.get_won_prizes
  end
end
