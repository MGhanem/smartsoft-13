class SearchController < ApplicationController
  def search
  end

  def show_results
  	@search_key = params[:q]
  	@age_from = params[:from]
  	@age_to = params[:to]
  	@country_id = params[:country_info]['country_id']
  	@gender_id = params[:gender_info]['gender_id']
  	@country = Country.find(@country_id)
  	@keyword = Keyword.where(:name => @search_key)

  end

end
