class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.references :developer

      t.timestamps
    end
    add_index :projects, :developer_id
  end
end
