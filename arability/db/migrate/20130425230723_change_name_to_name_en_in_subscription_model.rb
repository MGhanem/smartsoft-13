class ChangeNameToNameEnInSubscriptionModel < ActiveRecord::Migration
  def up
    rename_column :subscription_models, :name, :name_en
  end

  def down
    rename_column :subscription_models, :name_en, :name
  end
end
