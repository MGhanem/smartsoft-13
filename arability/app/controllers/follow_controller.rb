class FollowController < BackendController
  
  #mostafa hassaan
  def follow
    developer = Developer.where(:gamer_id => current_gamer.id).first
    keyword_ids = developer.keyword_ids
    word = Keyword.find(params[:keyword_id]).name
    if keyword_ids.include? params[:keyword_id]
      developer.follow(params[:keyword_id])
      redirect_to :search, :flash => {:success => "#{t(:follow_keyword_alert)} #{word}"}
    else
      redirect_to :search, :flash => {:fail => "#{t(:follow_keyword_alert_fail)} #{word}"}
    end
  end

  #mostafa hassaan
  def unfollow
    developer = Developer.where(:gamer_id => current_gamer.id).first
    developer.unfollow(params[:keyword_id])
    word = Keyword.find(params[:keyword_id]).name
    redirect_to :list_followed_words, :flash => {:success => "#{t(:unfollow_keyword_alert)} #{word}"}
  end
end
