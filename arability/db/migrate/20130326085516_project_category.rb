class ProjectCategory < ActiveRecord::Migration
  def change
  	create table :Project_Category do |t|
  	t.references :categories
  	t.references :projects
end
end
end