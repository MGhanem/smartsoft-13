class AddShowTutorialToGamer < ActiveRecord::Migration
  def change
    add_column :gamers, :show_tutorial, :boolean
  end
end
