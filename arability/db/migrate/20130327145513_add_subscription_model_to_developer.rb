class AddSubscriptionModelToDeveloper < ActiveRecord::Migration
  def change
  	change_table :developers do |t|
   		t.references :subscription_model
  end
end
