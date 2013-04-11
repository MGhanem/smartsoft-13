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
      #errors = dev.my_sub.get_permissions(dev_id, type)
      #if(errors.empty?)
        #all valid
        #continue save
      #else
        #Stop further actions
        
        #flash[:notice] = errors.join("\n")
      #end
      def get_permissions(dev_id,type)
        errors = []
        errors.empty?
        
        my_subscription = 
         MySubscription.joins(:developer).where(:developer_id => dev_id).first
        if type = @@search
          if my_subscription.word_search == 0 
            return false
          else
            return true
          end
        elsif  type = @@add
          if my_subscription.word_add == 0
            return false
          else
            return true
          end 
        else type = @@follow
          if @count < my_subscription.word_follow 
            return false
          else
            return true
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

    def self.choose(dev_id,sub_id)
      submodel = SubscriptionModel.find(sub_id)
      my_sub = MySubscription.where(:developer_id => dev_id).first
      if(my_sub == nil)
        my_sub = MySubscription.new
      end
      my_sub.developer_id = dev_id
      my_sub.word_search=submodel.limit_search
      my_sub.word_add=submodel.limit
      my_sub.word_follow=submodel.limit_follow
      my_sub.subscription_models_id = submodel.id
      if my_sub.save!
        return true
      else 
        return false
      end 
    end
    def decrement_word_add
    developer = Developer.find(self.developer_id)
    subscription = @developer.my_subscription
     if subscription.word_add !=0 
       subscription.word_add-=1
       subscription.save
    end
    end
    def decrement_word_search
    developer = Developer.find(self.developer_id) 
    subscription = @developer.my_subscription
     if subscription.word_add !=0 
       subscription.word_search-=1
       subscription.save
     end
 end
 def count_follow
  @developer = Developer.find(self.developer_id)
  @count_follow=@developer.Keywords.count

 end
end