class CreateTrohpies < ActiveRecord::Migration
  def up
    create_table :trohpies do |t|
      t.string :name
      t.integer :level
      t.integer :score
    end
  end

  def down
    drop_table :trophies
  end
end
