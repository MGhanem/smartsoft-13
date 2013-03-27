class CreateTableCategoriesKeywords < ActiveRecord::Migration
  def change
    create_table :categories_keywords do |t|
      t.references :category
      t.references :keyword
    end
  end
end
