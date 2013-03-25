class DropGamer < ActiveRecord::Migration
  def up
  	drop_table :gamers
    create_table :gamers
  	add_column :gamers, :username, :string
  	add_column :gamers, :age, :Integer
  	add_column :gamers, :country, :string
  	add_column :gamers, :education_level, :string
  	add_column :gamers, :highest_score, :Integer
  	add_column :gamers, :sign_up_status, :Integer
  end

  def down

  end
end
