class MySubscription < ActiveRecord::Base
  attr_accessible :developer, :word_add, :word_follow, :word_search
  belongs_to :developer

  def initialize(developer_id)
  	word_add=subscription_model.addlimit
  	word_search=subscription_model.searchlimit
  	word_follow=subscription_model.followlimit
  	project_add=subscription_model.projectlimit

  end
  def searchpermission(developer_id)

  	
  	if(word_search==0)
  		false
  	else 
  		word_search--


  end
  def followdec
  end
  def projdec
  end
  def adddec
  end
end
