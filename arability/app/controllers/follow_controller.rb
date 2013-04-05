class FollowController < ApplicationController
  def list_followed
    developer = Developer.where(:gamer_id => current_gamer.id).first
    keyword_ids_array = developer.keyword_ids
    @keywords = Keyword.find_all_by_id(keyword_ids_array)
  end
end
