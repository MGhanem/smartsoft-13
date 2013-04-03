class AddIsGuestToGamerModel < ActiveRecord::Migration
  def change
    add_column :gamer, :is_guest, :boolean
  end
end
