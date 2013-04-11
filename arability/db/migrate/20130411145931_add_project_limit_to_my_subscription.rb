class AddProjectLimitToMySubscription < ActiveRecord::Migration
  def change
  	add_column :subscription_models, :project, :integer
  end
end
