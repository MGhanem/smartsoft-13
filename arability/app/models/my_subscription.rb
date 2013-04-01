class MySubscription < ActiveRecord::Base
  belongs_to :subscription_model
  attr_accessible :developer, :word_add, :word_follow, :word_search, :subscription_models_id
  belongs_to :developer
  validates :subscription_models_id, :presence => true

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


