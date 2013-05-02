class AddDefaultValueToColumnInGamer < ActiveRecord::Migration
  def change
    change_column :gamers, :is_guest, :boolean, :default => false
  end
end
