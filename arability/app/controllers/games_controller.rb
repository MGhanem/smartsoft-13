class GamesController < ApplicationController
  def game
  end

  def vote
  end

  def record_vote
  end


  def getprizes
    @level = params[:level].to_i
    @score = params[:score].to_i
    @won_prizes = Prize.get_new_prizes_for_gamer(current_gamer.id, @score, @level)
    respond_to do |format|
      format.js
    end
  end



end
