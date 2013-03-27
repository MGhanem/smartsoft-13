class CategoriesProjects < ActiveRecord::Migration
  def up
  	drop_table :projects_categories
  	create_table :categories_projects do |t|
  		t.references :categories
  		t.references :projects
  	end
  end
end
