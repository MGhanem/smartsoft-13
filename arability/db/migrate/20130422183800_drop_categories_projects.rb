class DropCategoriesProjects < ActiveRecord::Migration
  def up
    drop_table :categories_project
  end

  def down
  end
end
