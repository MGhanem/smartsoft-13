class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :token
      t.references :project
      t.references :developer

      t.timestamps
    end
    add_index :api_keys, :project_id
    add_index :api_keys, :developer_id
  end
end
