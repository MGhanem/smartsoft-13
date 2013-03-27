class CategoriesProjects < ActiveRecord::Migration
  def up
  	drop_table :categories_projects
  	create_table :categories_projects do |t|
  	t.references :category
  	t.references :project
  end
end

  def down
  end
end
