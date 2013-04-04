class PagesController < ApplicationController
  def routing_error
    redirect_to "/", flash: {error: "Sorry, you have tried to access a non existing page \"#{params[:path]}\". You have been redirected to the home page"}
  end
end
