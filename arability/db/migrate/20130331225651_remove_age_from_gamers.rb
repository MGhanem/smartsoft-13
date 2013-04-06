class RemoveAgeFromGamers < ActiveRecord::Migration
  def up
    remove_column :gamers, :age
  end

  def down
    add_column :gamers, :age, :Integer
  end
end
