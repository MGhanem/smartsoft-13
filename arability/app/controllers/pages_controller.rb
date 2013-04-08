  #require "koala"
class PagesController < ApplicationController

  def home
  		#@graph = Koala::Facebook::GraphAPI.new(155521981280754|yRtdxQ-tSd00v0KEnptk8WK8bZM) # pre 1.2beta
	
  end

  def post
	@graph = Koala::Facebook::API.new("BAACEdEose0cBADPNP6sJt8PUPNCX5xC0HrcE393iZAHieQijMZBzMJD3uZCWrGgNu8oZAKZBZCXbg8aZB70LByDsMtEqVPdkCllZB6cmUT0bL1fGBVqGjbJ3") # 1.2beta and beyond
	@graph.put_wall_post("fb button")
	render 'pages/home'
  end

end
