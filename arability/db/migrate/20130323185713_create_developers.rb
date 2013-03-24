class CreateDevelopers < ActiveRecord::Migration
  def change
    create_table :developers do |t|
      t.references :gamer

      t.timestamps
    end
    add_index :developers, :gamer_id
  end
end
