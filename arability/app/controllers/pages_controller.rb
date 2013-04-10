#encoding: utf-8
class PagesController < ApplicationController

  def home
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
    def post
      token = Gamer.fetToken(current_gamer.id)
      @graph = Koala::Facebook::API.new(token)
      @graph.put_wall_post("لقد حصلت على ١٢٣ نقطة في عربيلتي")
      render 'pages/home'
    end

end
