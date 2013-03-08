class AddOidToLists < ActiveRecord::Migration
  def change
    add_column :lists, :oid, :integer

  end
end
