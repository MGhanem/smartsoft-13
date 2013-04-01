class CreateTrophies < ActiveRecord::Migration
  def up
    create_table :trophies do |t|
      t.string :name
      t.integer :level
      t.integer :score
    end
  end

  def down
    drop_table :trophies
  end
end

