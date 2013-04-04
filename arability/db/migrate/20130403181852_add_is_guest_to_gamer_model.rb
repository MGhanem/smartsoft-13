class AddIsGuestToGamerModel < ActiveRecord::Migration
  def change
    add_column :games, :is_guest, :boolean
  end
end
