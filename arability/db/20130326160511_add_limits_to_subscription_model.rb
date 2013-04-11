class AddLimitsToSubscriptionModel < ActiveRecord::Migration
  def change
  	add_column :subscription_models, :limit_search, :integer
  	add_column :subscription_models, :limit_follow, :integer
  	add_column :subscription_models, :limit_project, :integer
  end
end
