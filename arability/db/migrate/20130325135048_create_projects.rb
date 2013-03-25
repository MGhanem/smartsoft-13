class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.references :category
      t.boolean :formal
      t.integer :minAge
      t.integer :maxAge
      t.string :developer_id
      t.text :description
      t.references :keywords

      t.timestamps
    end
    add_index :projects, :category_id
    add_index :projects, :keywords_id
  end
end
