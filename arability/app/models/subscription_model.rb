class SubscriptionModel < ActiveRecord::Base
	has_many :my_subscriptions
  attr_accessible :name, :limit_search, :limit_follow, :limit_project ,:limit
end
