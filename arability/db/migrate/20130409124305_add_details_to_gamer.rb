class AddDetailsToGamer < ActiveRecord::Migration
  def change
    add_column :gamers, :token, :string
    add_column :gamers, :token_secret, :string
  end
end
