class AddBirthDateToGamers < ActiveRecord::Migration
  def change
    add_column :gamers, :date_of_birth, :date
  end
end
