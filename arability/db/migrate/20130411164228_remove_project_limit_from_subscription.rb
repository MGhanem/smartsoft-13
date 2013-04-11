class RemoveProjectLimitFromSubscription < ActiveRecord::Migration
  def up
  	remove_column :subscription_models, :project
  end

  def down
  end
end
