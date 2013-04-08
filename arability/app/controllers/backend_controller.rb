class BackendController < ApplicationController
  layout "backend"
  def home
    redirect_to projects_path

  end
end
