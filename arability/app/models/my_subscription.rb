class MySubscription < ActiveRecord::Base
  attr_accessible :developer_id, :word_add, :word_follow, :word_search
  belongs_to :developer
  belongs_to :subscription_model
  class << self
# author:Noha hesham
# Description:
#  takes the developer id and integer type and checks wether 
#  the developer's word search ,word add and word follow
#  limit has been reached ,if its not then it is greater than zero 
#  and permission is given by returning true else return false
#  and permission denied.
# params:
#  developer id and type
# success:
#  permission is given if the developer didnt exceed the search ,add
#  or follow limit
# fail:
#  none
    def give_permissions(dev_id,type)
      my_subscription = 
      MySubscription.joins(:developer).where(:developer_id => dev_id).first
      if type == 1
        if my_subscription.word_search > 0 
          return true
        else
          return false
        end
      elsif  type == 2
        if my_subscription.word_add > 0
          return true
        else 
          return false
        end 
      else type == 3
        if my_subscription.word_follow > 0
          return true
        else
          return false
        end
      end
    end
  end 
end

