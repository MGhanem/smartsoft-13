class AddAdminToGamers < ActiveRecord::Migration
  def change
    add_column :gamers, :admin, :boolean, :default => false
  end
end
