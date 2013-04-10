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

  # author:
  #   Mostafa Hassaan
  # description:
  #     function removes relation between a develoepr and a keyword
  # params:
  #     keyword_id: id of the keyword to unfollow
  #     gamer_id: id used to get the developer
  # success:
  #     calls unfollow method in Developer model and with needed parameters 
  #       to remove the realtion between the developer and the keyword
  #         , returning true.
  #           Then it redirects to the search page again with a success flash 
  #             to alert the developer that the relation has been remove
  # failure:
  #     returns false if the relation didn't already exsist in the database
  def unfollow
    developer = Developer.where(:gamer_id => current_gamer.id).first
    developer.unfollow(params[:keyword_id])
    word = Keyword.find(params[:keyword_id]).name
    redirect_to :list_followed_words, :flash => {:success => "#{t(:unfollow_keyword_alert)} #{word}"}
  end
end
