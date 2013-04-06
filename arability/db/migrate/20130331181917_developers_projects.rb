class DevelopersProjects < ActiveRecord::Migration
  def up
  	create_table :developers_projects do |t|
  		t.references :developer
  		t.references :project
  	end
  end

  def down
  end
end