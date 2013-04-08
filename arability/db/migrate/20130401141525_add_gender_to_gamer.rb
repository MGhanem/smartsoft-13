class AddGenderToGamer < ActiveRecord::Migration
  def change
    add_column :gamers, :gender, :string
  end
end
