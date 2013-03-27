class SubscriptionModel < ActiveRecord::Base
	has_many :my_subscriptions
  # attr_accessible :title, :body
#def find_add_limit
	#@limit=SubscriptionModel.find(:limit)
#end

 
end
