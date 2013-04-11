class ChangeSubscriptionModelRelation < ActiveRecord::Migration
  def up
  	remove_column :my_subscriptions, :subscription_models_id
  	add_column :my_subscriptions, :subscription_model_id
  end

  def down
  end
end
