class AddLimitsToSubscriptionModel < ActiveRecord::Migration
  def change
  	add_column :subscription_model, :limit_search, :integer
  	add_column :subscription_model, :limit_follow, :integer
  	add_column :subscription_model, :limit_project, :integer
  end
end
