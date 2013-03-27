class DropDeveloper < ActiveRecord::Migration
   def up
   	change_table :developers do |t|
   		t.string :first_name
   		t.string :last_name
   		t.boolean :verified 
   	end
   end

  def down
  end
end
