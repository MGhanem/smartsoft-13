class CreatePrizes < ActiveRecord::Migration
  def up
    create_table :prizes do |t|
      t.string :name
      t.integer :level
      t.integer :score
    end
  end

  def down
    drop_table :prizes
  end
end
