class ChangeSubscriptionModel < ActiveRecord::Migration
  def up
  	change_table :subscription_models do |t|
   		t.string :name
   	end
  end

  def down
  end
end
