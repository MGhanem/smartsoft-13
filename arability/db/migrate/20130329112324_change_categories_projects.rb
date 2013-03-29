class ChangeCategoriesProjects < ActiveRecord::Migration
  def up 
  	rename_column :categories_projects, :categories_id, :category_id
  	rename_column :categories_projects, :projects_id, :project_id
  end

  def down
  end
end
