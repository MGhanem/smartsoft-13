class MySubscription < ActiveRecord::Base
  attr_accessible :developer, :word_add, :word_follow, :word_search, :subscription_models_id
  belongs_to :developer
  validates :subscription_models_id, :presence => true
end
