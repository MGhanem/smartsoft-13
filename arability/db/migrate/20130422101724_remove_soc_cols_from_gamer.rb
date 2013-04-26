class RemoveSocColsFromGamer < ActiveRecord::Migration
  def up
    remove_column :gamers, :provider
    remove_column :gamers, :uid
    remove_column :gamers, :gprovider
    remove_column :gamers, :gid
    remove_column :gamers, :token
    remove_column :gamers, :token_secret
  end

  def down
    add_column :gamers, :token_secret, :string
    add_column :gamers, :token, :string
    add_column :gamers, :gid, :string
    add_column :gamers, :gprovider, :string
    add_column :gamers, :uid, :string
    add_column :gamers, :provider, :string
  end
end
