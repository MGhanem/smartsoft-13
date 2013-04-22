 class MySubscription < ActiveRecord::Base
  belongs_to :subscription_model
  attr_accessible :developer, :word_add, :word_follow, :word_search, :subscription_model_id
  belongs_to :developer
  validates :subscription_model_id, :presence => true
  # Author:
  #   Noha Hesham
  # Description:
  #   It finds the chosen subscription model by the developer 
  #   and sets the limits in the subscription model
  #   to the developers my subscription
  # Success:
  #   The limits are set in the my subscription of the developer
  # Failure:
  #   The limits are not put in the my subscription of the developer
  def self.choose(dev_id, sub_id)
      submodel = SubscriptionModel.find(sub_id)
      my_sub = MySubscription.where(:developer_id => dev_id).first
      if(my_sub == nil)
        my_sub = MySubscription.new
      end
      my_sub.developer_id = dev_id
      my_sub.word_search = submodel.limit_search
      my_sub.word_add = submodel.limit
      my_sub.word_follow = submodel.limit_follow
      my_sub.project = submodel.limit_project
      my_sub.subscription_model_id = submodel.id
      if my_sub.save
        return true
      else 
        return false
      end 
    end

  class << self
    # Author:
    #    Noha hesham
    # Description:
    #    Takes the developer id and integer type and checks wether 
    #    the developer's word search ,word add and word follow
    #    limit has been reached ,if its not then it is greater than zero 
    #    and permission is given by returning true else return false
    #    and permission denied.
    # Params:
    #    Developer id and type
    # Success:
    #    Permission is given if the developer didnt exceed the search ,add
    #    or follow limit
    # Fail:
    #    None
      def get_permission_follow(dev_id)
        my_subscription = 
         MySubscription.joins(:developer).where(:developer_id => dev_id).first
          if @count < my_subscription.word_follow 
            return true
          else
            return false
          end
        end        
    # Author:
    #   Noha Hesham
    # Description:
    #   Counts the number of the followed word by the
    #   developer till now
    # Success:
    #   Gets the correct number of words counted
    # Failure:
    #   None 
   def count_follow
    @developer = Developer.find(self.developer_id)
    @count_follow=@developer.Keywords.count   
  end
  end
end