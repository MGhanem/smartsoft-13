class SearchController < ApplicationController
  def index
  	@similar_keywords = Keyword.get_similar_keywords(:params['q'])
  end
end
