class AddGenderToGamers < ActiveRecord::Migration
  def change
    add_column :gamers, :gender, :boolean
  end
end
