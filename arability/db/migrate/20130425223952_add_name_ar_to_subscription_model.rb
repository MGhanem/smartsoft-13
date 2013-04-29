class AddNameArToSubscriptionModel < ActiveRecord::Migration
  def change
  	add_column :subscription_models, :name_ar, :string
  end
end
