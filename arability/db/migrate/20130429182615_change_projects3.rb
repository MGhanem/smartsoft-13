class ChangeProjects3 < ActiveRecord::Migration
  def up
    add_column :projects, :gender, :boolean
  end

  def down
  end
end
