class SubscriptionModel < ActiveRecord::Base
  attr_accessible :name, :limit_search, :limit_follow, :limit_project
end
