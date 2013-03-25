class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.references :category
      t.boolean :formal
      t.integer :minAge
      t.integer :maxAge
      t.string :creatorid
      t.text :description
      t.references :words
      t.references :sharedWith

      t.timestamps
    end
    add_index :projects, :category_id
    add_index :projects, :words_id
    add_index :projects, :sharedWith_id
  end
end
