class PagesController < ApplicationController
  def routing_error
    redirect_to "/", flash: {error: "Sorry, you have tried to access a non existing page \"#{params[:path]}\". An admin has been notified of your error"}
  end
end
