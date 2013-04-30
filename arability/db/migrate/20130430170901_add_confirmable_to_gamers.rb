class AddConfirmableToGamers < ActiveRecord::Migration
  def self.up
    change_table(:gamers) do |t|
      t.confirmable
    end
    add_index :gamers, :confirmation_token, unique: true
  end

  def self.down
    remove_column :gamers, :confirmable
  end
end


