class AddColumnsToGamers < ActiveRecord::Migration
  def change
    add_column :gamers, :gprovider, :string
    add_column :gamers, :gid, :string
  end
end