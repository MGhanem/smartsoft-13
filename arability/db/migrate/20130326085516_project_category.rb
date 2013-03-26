class ProjectCategory < ActiveRecord::Migration
  def change
  	t.references :categories
  	t.references :projects
end
