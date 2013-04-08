class AddTokenSecretToGamer < ActiveRecord::Migration
  def change
    add_column :gamers, :token_secret, :string
  end
end
