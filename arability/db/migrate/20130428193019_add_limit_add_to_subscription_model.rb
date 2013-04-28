class AddLimitAddToSubscriptionModel < ActiveRecord::Migration
  def change
  	add_column :subscription_model, :limit_add, :integer
  end
end
