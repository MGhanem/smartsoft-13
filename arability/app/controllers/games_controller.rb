# encoding: UTF-8
class GamesController < ApplicationController
  def game
  end

  def vote
  end

  def record_vote

  end
  
  # Author:
  #   Omar Hossam
  # Description:
  #   As a gamer, I could post my score on my facebook timeline by pressing on
  #   the facebook share score button.
  # Parameters:
  #   None.
  # Success:
  #   Gamer presser the facebook share score button, and his score is shared on
  #   facebook and confirmed by API.
  # Failure: 
  #   Facebook failure reported by API.
  def post_score_facebook
    token = Gamer.getToken(current_gamer.id)
    @graph = Koala::Facebook::API.new(token)
    score = params[:score]
    @graph.put_wall_post("لقد حصلت على #{score} نقطة في عربيلتي")
    render "games/share-facebook"
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
end
