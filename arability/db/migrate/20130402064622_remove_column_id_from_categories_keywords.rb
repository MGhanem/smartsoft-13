class RemoveColumnIdFromCategoriesKeywords < ActiveRecord::Migration
  def up
    remove_column :categories_keywords, :id
  end

  def down
  end
end
