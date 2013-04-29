class ChangeProjects2 < ActiveRecord::Migration
  def up
    add_column :projects, :country, :string
    add_column :projects, :education_level, :string
  end

  def down
  end
end
