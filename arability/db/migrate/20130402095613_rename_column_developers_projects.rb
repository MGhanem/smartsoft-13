class RenameColumnDevelopersProjects < ActiveRecord::Migration
  def up
    rename_column :developers_projects, :project_id, :shared_with_projects
    create_table :developer_projects do |t|
      t.references :own_projects
      t.references :project_owner
    end
  end

  def down
  end
end
