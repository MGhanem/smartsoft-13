#encoding: utf-8
class PagesController < ApplicationController

  def home
  end

  def post
    token = Gamer.fetToken(current_gamer.id)
	  @graph = Koala::Facebook::API.new(token)
	  @graph.put_wall_post("لقد حصلت على ١٢٣ نقطة في عربيلتي")
	  render 'pages/home'
  end

end
