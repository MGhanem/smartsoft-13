class DropDeveloperModel < ActiveRecord::Migration
  def up
   	remove_column :developers, :first_name
   	remove_column :developers, :last_name
  end

  def down
  end
end
