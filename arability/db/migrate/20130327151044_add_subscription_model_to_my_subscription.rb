class AddSubscriptionModelToMySubscription < ActiveRecord::Migration
  def change
  	change_table :my_subscriptions do |t|
   		t.references :subscription_models
   	end
  end
end
