class CreateSubscriptionModels < ActiveRecord::Migration
  def change
    create_table :subscription_models do |t|

      t.timestamps
    end
  end
end
