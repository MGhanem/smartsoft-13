class AddLastResetToMySubscription < ActiveRecord::Migration
  def change
  	add_column :my_subscriptions, :last_reset, :date
  end
end
