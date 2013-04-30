class AddConfirmableToGamers < ActiveRecord::Migration
  def self.up
    add_column :gamers, :confirmation_token, :string
    add_column :gamers, :confirmed_at,       :datetime
    add_column :gamers, :confirmation_sent_at , :datetime

    add_index  :gamers, :confirmation_token, :unique => true
  end
  def self.down
    remove_index  :gamers, :confirmation_token

    remove_column :gamers, :confirmation_sent_at
    remove_column :gamers, :confirmed_at
    remove_column :gamers, :confirmation_token
  end
end
