class Search < ActiveRecord::Base
  attr_accessible :developer_id, :synonym_id
  belongs_to :keyword
  belongs_to :developer

  def get_search_permission(word_id,dev_id)
  	my_subscription = 
         MySubscription.joins(:developer).where(:developer_id => dev_id).first
    word = Search.joins(:keyword).where(:keyword_id => word_id)
    developer = Search.joins(:developer).where(:developer_id => dev_id)
    if Search.find(keyword_id => word_id)!= nil
    	return true
    else 
    	
  end

end
