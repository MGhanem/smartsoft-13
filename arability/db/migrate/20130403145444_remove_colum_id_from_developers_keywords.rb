class RemoveColumIdFromDevelopersKeywords < ActiveRecord::Migration
  def up
    remove_column :developers_keywords, :id
  end

  def down
  end
end
