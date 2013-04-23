class AddAdminToGamers < ActiveRecord::Migration
  def change
    add_column :gamers, :admin, :boolean
  end
end
