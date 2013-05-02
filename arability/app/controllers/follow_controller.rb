class FollowController < BackendController
  before_filter :authenticate_gamer!
  before_filter :authenticate_developer!

  # author:
  #   Mostafa Hassaan
  # description:
  #   function creates relation between a develoepr and a keyword
  # params:
  #   keyword_id: id of the keyword to follow
  #   gamer_id: id used to get the developer
  # success:
  #   calls follow method in Developer model and with needed parameters 
  #   to create the realtion between the developer and the keyword,
  #   returning true.
  #   Then it redirects to the search page again with a success flash 
  #   to alert the developer that the relation has been created
  # failure:
  #   fails if the relation between the developer and the keyword already 
  #   exists, returning false. Then it redirects the developer to the 
  #   search page with a failure flash to alert the developer that the
  #   relation failed.
  def follow
    developer = Developer.where(gamer_id: current_gamer.id).first
    if developer.my_subscription.get_permission_follow
      keyword_ids = developer.keyword_ids
      word = Keyword.where(id: params[:keyword_id]).first
      if word != nil
        if keyword_ids.include? params[:keyword_id].to_i
          redirect_to :search_keywords, flash: {fail: "#{t(:follow_keyword_alert_fail)} #{word.name}"}
        else
          developer.follow(params[:keyword_id])
          redirect_to :search_keywords, flash: {success: "#{t(:follow_keyword_alert)} #{word.name}"}
        end
      else
         redirect_to :search_keywords, flash: {fail: "#{t(:keyword_not_found)}"}
      end
    end
  end

  # author:
  #   Mostafa Hassaan
  # description:
  #   function removes relation between a develoepr and a keyword
  # params:
  #   keyword_id: id of the keyword to unfollow
  #   gamer_id: id used to get the developer
  # success:
  #   calls unfollow method in Developer model and with needed parameters 
  #   to remove the realtion between the developer and the keyword,
  #   returning true.
  #   Then it redirects to the search page again with a success flash 
  #   to alert the developer that the relation has been remove
  # failure:
  #   returns false if the relation didn't already exsist in the database
  def unfollow   
    word = Keyword.where(id: params[:keyword_id]).first
    if word != nil
      developer = Developer.where(gamer_id: current_gamer.id).first
      developer.unfollow(params[:keyword_id])
      word = Keyword.find(params[:keyword_id]).name
      redirect_to :list_followed_words, flash: {success: "#{t(:unfollow_keyword_alert)} #{word}"}
    else
      redirect_to :list_followed_words, flash: {fail: "#{t(:keyword_not_found)}"}
    end
  end
  

  # author:
  #   Mostafa Hassaan
  # description:
  #   function returns a hash with all keywords followed by a developer
  # params:
  #   gamer_id: id used to get the developer
  # success:
  #   returns a hash containing all keywords followed by the given developer
  # failure:
  #   returns empty hash if the developer doesn't follow any keywords
  def list_followed
    developer = Developer.where(gamer_id: current_gamer.id).first
    keyword_ids_array = developer.keyword_ids
    @keywords = Keyword.find_all_by_id(keyword_ids_array)
  end
end

  
