class AddIsGuestToGamerModel < ActiveRecord::Migration
  def change
    add_column :gamers, :is_guest, :boolean
  end
end
