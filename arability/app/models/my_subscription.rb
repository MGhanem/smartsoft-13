class MySubscription < ActiveRecord::Base
  attr_accessible :developer, :word_add, :word_follow, :word_search
  belongs_to :developer
  belongs_to :subscription_model

  
  def decrement_limit(attr)

  	old_limit = self.send(attr)
  	if old_limit > 0
  	self.update_attribute(attr, old_limit - 1)
  else

  end
  end

  def self.search_word_permission
  	if self.word_search > 0 
  		return true
  	else
  		return false
  end

  def self.add_word_permission
  	if self.word_add > 0
  		return true
  	else 
  		return false

  	
  end

  def self.follow_word_permission
  	if self.word_follow > 0
  	    return true
  	else
  		return false
  end

  
end
