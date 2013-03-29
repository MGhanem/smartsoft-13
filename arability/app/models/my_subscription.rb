class MySubscription < ActiveRecord::Base
<<<<<<< HEAD
  attr_accessible :developer_id, :word_add, :word_follow, :word_search
  belongs_to :developer
  belongs_to :subscription_model

  @@search=1
  @@add=2
  @@follow=3

  class << self
    # author:Noha hesham
    # Description:
    #   takes the developer id and integer type and checks wether 
    #   the developer's word search ,word add and word follow
    #   limit has been reached ,if its not then it is greater than zero 
    #   and permission is given by returning true else return false
    #   and permission denied.
    # params:
    #   developer id and type
    # success:
    #   permission is given if the developer didnt exceed the search ,add
    #   or follow limit
    # fail:
    #   none
      def get_permissions(dev_id,type)
        my_subscription = 
         MySubscription.joins(:developer).where(:developer_id => dev_id).first
        if type = @@search
          if my_subscription.word_search > 0 
            return true
          else
            return false
          end
        elsif  type = @@add
          if my_subscription.word_add > 0
            return true
          else 
            return false
          end 
        else type = @@follow
          if my_subscription.word_follow > 0
            return true
          else
            return false
          end
        end
      end
  end 
   def get_word_search
      return @@search
    end
    def get_word_add
      return @@add
    end
    def get_word_follow
      return @@follow
    end
end
=======
  attr_accessible :developer, :word_add, :word_follow, :word_search, :subscription_models_id
  belongs_to :developer
  validates :subscription_models_id, :presence => true
end
>>>>>>> 463444f8b41e4ee4ba1b41e4b340e648e86a2c9f
