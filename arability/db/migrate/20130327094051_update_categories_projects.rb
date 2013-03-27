class UpdateCategoriesProjects < ActiveRecord::Migration
  def up
  	change_table :categories_projects do |t|
  		t.remove :categories
  		t.remove :projects
    	t.references :category
    	t.references :project
    end
end

  def down
  end
end
