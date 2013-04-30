class AddColumnProviderToGamers < ActiveRecord::Migration
  def change
  	add_column :gamers, :provider, :string
  end
end
