class AddIsLocalToGamers < ActiveRecord::Migration
  def change
    add_column :gamers, :is_local, :boolean, :default => true
  end
end
