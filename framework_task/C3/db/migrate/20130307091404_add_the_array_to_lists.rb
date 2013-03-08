class AddTheArrayToLists < ActiveRecord::Migration
  def change
    add_column :lists, :thearray, :text

  end
end
