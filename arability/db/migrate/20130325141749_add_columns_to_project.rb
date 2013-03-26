class AddColumnsToProject < ActiveRecord::Migration
  def change
    add_column :projects, :developer_id, :string
  end
end