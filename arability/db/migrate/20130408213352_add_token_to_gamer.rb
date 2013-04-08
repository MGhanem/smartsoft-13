class AddTokenToGamer < ActiveRecord::Migration
  def change
    add_column :gamers, :token, :string
  end
end
