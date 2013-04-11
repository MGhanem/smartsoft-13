class MySubscription < ActiveRecord::Base
  attr_accessible :developer_id, :word_add, :word_follow, :word_search, :subscription_model_id
  belongs_to :developer
  belongs_to :subscription_model
  validates :subscription_models_id, :presence => true
end
