class DropProjectWord < ActiveRecord::Migration
  def up
  	drop_table :project_words
  end

  def down
  end
end
