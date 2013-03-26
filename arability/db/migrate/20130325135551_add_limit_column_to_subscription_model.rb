class AddLimitColumnToSubscriptionModel < ActiveRecord::Migration
  def change
    add_column :subscription_models, :limit, :integer
  end
end
