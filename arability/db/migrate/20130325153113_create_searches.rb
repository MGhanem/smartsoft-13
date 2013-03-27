class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.integer :developer_id
      t.integer :synonym_id

      t.timestamps
    end
  end
end
