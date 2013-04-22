class CategoryMigration < ActiveRecord::Migration
  def up
    change_table(:categories) do |t|
      t.remove :name
      t.string :english_name
      t.string :arabic_name
    end
  end

  def down
    change_table(:categories) do |t|
      t.string :name
    end
  end
end
