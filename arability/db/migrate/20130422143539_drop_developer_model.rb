class DropDeveloperModel < ActiveRecord::Migration
  def up
  	change_table :developers do |t|
   		remove_column :first_name
   		remove_column :last_name
   	end
  end

  def down
  end
end
