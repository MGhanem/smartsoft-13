class DropDeveloper < ActiveRecord::Migration
   def up
  	drop_table :developers
    create_table :developers do |t|
    	t.references :gamer
		t.string :first_name
		t.string :last_name
		t.boolean :verified 
		t.boolean :blocked , :default => 'false'
    end
  end

  def down
  end
end
