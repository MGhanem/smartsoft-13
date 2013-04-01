class CreateProjectWords < ActiveRecord::Migration
  def change
    create_table :project_words do |t|
      t.references :project
      t.references :keyword
      t.references :synonym

      t.timestamps
    end
    add_index :project_words, :project_id
    add_index :project_words, :keyword_id
    add_index :project_words, :synonym_id
  end
end
