class GamesController < ApplicationController
  def game
  end

  def vote
  end

  def record_vote
  end

  def post
    begin
      token = curret_gamer.getToken
      # raise Exception, token
      @graph = Koala::Facebook::API.new(token)
      @graph.put_wall_post("Checkout the new Arability game @ www.arability.net")
      redirect_to '/game', :flash => {success: "You get extra brownie points"}
    rescue Koala::Facebook::AuthenticationError
      redirect_to "/gamers/auth/facebook"
    rescue Koala::Facebook::ClientError
      redirect_to "/game", :flash => {notice: "We're very sorry but we don't want to spam your timeline"}
    end
  end

  def disconnect_facebook
    current_gamer.disconnect_from_facebook
    redirect_to "/gamers/edit", :flash => {alert: "Your facebook account was disconnected"}
  end
end
