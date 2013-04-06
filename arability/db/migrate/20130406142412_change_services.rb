class ChangeServices < ActiveRecord::Migration
  def up
  	rename_column :services :user_id, :gamer_id
  end

  def down
  end
end
