class ChangeDevelopersProjects < ActiveRecord::Migration
  def up
  	def change
  		rename_column :developers_projects, :developer_id, :shared_with_id
  	end
  end

  def down
  end
end
