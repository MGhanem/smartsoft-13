class FollowController < BackendController
  
  # author:
  #   Mostafa Hassaan
  # description:
  #     function creates relation between a develoepr and a keyword
  # params:
  #     keyword_id: id of the keyword to follow
  #     gamer_id: id used to get the developer
  # success:
  #     calls follow method in Developer model and with needed parameters 
  #       to create the realtion between the developer and the keyword
  #         , returning true.
  #           Then it redirects to the search page again with a success flash 
  #             to alert the developer that the relation has been created
  # failure:
  #     fails if the relation between the developer and the keyword already 
  #       exists, returning false. Then it redirects the developer to the 
  #         search page with a failure flash to alert the developer that the
  #           relation failed.
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
end
