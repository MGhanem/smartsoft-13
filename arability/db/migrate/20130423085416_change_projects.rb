class ChangeProjects < ActiveRecord::Migration
  def up
    add_column :projects, :category_id, :integer
    add_column :projects, :country, :string
    add_column :projects, :education_level, :string
  end

  def down
  end
end
