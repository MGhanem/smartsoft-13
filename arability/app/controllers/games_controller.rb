class GamesController < ApplicationController
  def game
  end

  def vote
  end

  def record_vote
  end

  # Author:
  #   Amr Abdelraouf
  # Description:
  #   When called the method envokes the current gamer's 'getToken' to get 
  #   his/her facebook token and posts an invitation message on his/her row
  # Params:
  #   None
  # Success:
  #   User is connected, token is valid and the wall post is posted to the
  #   user's wall
  # Failure:
  #   The user is not connected: S/He's redirected to the settings page
  #   The user's token has expired: S/He will be redirected to the Facebook
  #   reauthentication page
  #   The user is trying to post more than once in a short period of time
  #   (facebook doesn't allow this to discourage spamming) a flash notice
  #   will appear explaining the situation
  #   The user is not signed in: S/He'll be redirected to the sign in page
  def post
    if current_gamer != nil
      if !current_gamer.is_connected_to_facebook 
        redirect_to "/gamers/edit", :flash => {notice: t(:connect_your_account)}
      else
        begin
          token = current_gamer.getToken
          @graph = Koala::Facebook::API.new(token)
          @graph.put_wall_post("Checkout the new Arability game @ www.arability.net")
          redirect_to '/game', :flash => {success: t(:shared_on_fb)}
        rescue Koala::Facebook::AuthenticationError
          redirect_to "/gamers/auth/facebook"
        rescue Koala::Facebook::ClientError
          redirect_to "/game", :flash => {notice: t(:error_fb)}
        end
      end
    else
      redirect_to "/gamers/sign_in", :flash => {notice: t(:sign_in_facebook)}
    end
  end

  # Author:
  #   Amr Abdelraouf
  # Description:
  #   When called the gammer will disconnect his/her account from facebook
  # Params:
  #   None
  # Success:
  #   The user's facebook data will be deleted and a flash notice will appear
  #   to ensure the user that he's disconnected
  # Failure:
  #   None
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
