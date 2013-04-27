class ChangeProjects < ActiveRecord::Migration
  def up
    add_column :projects, :category_id, :integer
  end

  def down
  end
end
