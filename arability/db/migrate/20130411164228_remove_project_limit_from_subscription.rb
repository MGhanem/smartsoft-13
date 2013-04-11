class RemoveProjectLimitFromSubscription < ActiveRecord::Migration
  def up
  	remove_column :subscription_models, :project
  	add_column :my_subscriptions, :project, :integer
  end

  def down
  end
end
