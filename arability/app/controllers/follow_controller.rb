class FollowController < ApplicationController

  def unfollow
    developer = Developer.where(:gamer_id => current_gamer.id).first
    developer.unfollow(params[:keyword_id])
    word = Keyword.find(params[:keyword_id]).name
    redirect_to :list_followed_words, :flash => {:success => "'#{word}' has been unfollowed"}
  end
  
  def list_followed
    developer = Developer.where(:gamer_id => current_gamer.id).first
    keyword_ids_array = developer.keyword_ids
    @keywords = Keyword.find_all_by_id(keyword_ids_array)
  end
end
