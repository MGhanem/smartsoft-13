class CreateGamers < ActiveRecord::Migration
  def change
    create_table :gamers do |t|
		t.string :name
		t.string :username
		t.integer :sign_up_status , :default => 0
		t.string :country
		t.date :date_of_birth
		t.database_authenticatable
	    t.confirmable
	    t.recoverable
	    t.rememberable
	    t.trackable
	    t.lockable

      t.timestamps
    end
  end
end
