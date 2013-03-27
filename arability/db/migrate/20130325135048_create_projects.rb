class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.references :categories
      t.boolean :formal
      t.integer :minAge
      t.integer :maxAge
      t.references :developer
      t.text :description

      t.timestamps
    end
    add_index :projects, :category_id
  end
end
