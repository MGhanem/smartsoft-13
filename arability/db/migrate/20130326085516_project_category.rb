class ProjectCategory < ActiveRecord::Migration
  def change
  	create_table :projects_categories do |t|
  		t.references :categories
  		t.references :projects
		end
	end
end