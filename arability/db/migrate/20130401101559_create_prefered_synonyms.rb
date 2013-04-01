class CreatePreferedSynonyms < ActiveRecord::Migration
  def change
    create_table :prefered_synonyms do |t|
      t.references :project
      t.references :keyword
      t.references :synonym

      t.timestamps
    end
    add_index :prefered_synonyms, :project_id
    add_index :prefered_synonyms, :keyword_id
    add_index :prefered_synonyms, :synonym_id
  end
end
