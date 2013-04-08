class AddColumnsToGamers < ActiveRecord::Migration
  def change
    add_column :gamers, :provider, :string
    add_column :gamers, :uid, :string
  end
end
