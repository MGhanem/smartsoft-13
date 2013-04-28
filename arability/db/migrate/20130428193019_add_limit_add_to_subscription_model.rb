class AddLimitAddToSubscriptionModel < ActiveRecord::Migration
  def change
  	add_column :subscription_models, :limit_add, :integer
  end
end
