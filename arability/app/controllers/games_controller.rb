class GamesController < ApplicationController
  def game
  end

  def vote
  end

  def record_vote
  end

  def post
    if !current_gamer.is_connected_to_facebook
      redirect_to "/gamers/edit", :flash => {notice: t(:connect_your_account)}
    else
      begin
        token = current_gamer.getToken
        # raise Exception, token
        @graph = Koala::Facebook::API.new(token)
        @graph.put_wall_post("Checkout the new Arability game @ www.arability.net")
        redirect_to '/game', :flash => {success: t(:shared_on_fb)}
      rescue Koala::Facebook::AuthenticationError
        redirect_to "/gamers/auth/facebook"
      rescue Koala::Facebook::ClientError
        redirect_to "/game", :flash => {notice: t(:error_fb)}
      end
    end
  end

  def disconnect_facebook
    current_gamer.disconnect_from_facebook
    redirect_to "/gamers/edit", :flash => {alert: t(:logged_out_of_fb)}
  end

  def getprizes
    @level = params[:level].to_i
    @score = params[:score].to_i
    @won_prizes = Prize.get_new_prizes_for_gamer(current_gamer.id, @score, @level)
    respond_to do |format|
      format.js
    end
  end

  def record_synonym
  end

end
