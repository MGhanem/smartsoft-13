class CreateSharedProjects < ActiveRecord::Migration
  def change
  	drop_table :developers_projects
    create_table :shared_projects ,:id => false do |t|
      t.integer :project_id
      t.integer :developer_id
      t.timestamps
    end
 end   
end
