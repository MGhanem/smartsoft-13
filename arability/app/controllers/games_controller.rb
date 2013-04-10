class GamesController < ApplicationController
  def game
  end

  def vote
  end

  def record_vote
  end

  def post
    token = Gamer.getToken(current_gamer.id)
    @graph = Koala::Facebook::API.new(token)
    @graph.put_wall_post("Checkout the new Arability game @ www.arability.net")
    render '/game'
  end
end
