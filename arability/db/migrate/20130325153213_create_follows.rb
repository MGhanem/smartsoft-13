class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows do |t|
      t.integer :developer_id
      t.integer :keyword_id

      t.timestamps
    end
  end
end
