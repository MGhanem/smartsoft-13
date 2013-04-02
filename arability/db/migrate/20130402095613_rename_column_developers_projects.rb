class RenameColumnDevelopersProjects < ActiveRecord::Migration
  def up
    rename_column :developers_projects, :project_id, :shared_with_projects
    remove_column :developers_projects, :id
    remove_column :projects, :category_id
    rename_column :projects, :developer_id, :owner_id
  end

  def down
  end
end
