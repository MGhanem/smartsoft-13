class CreateSynonyms < ActiveRecord::Migration
  def change
    create_table :synonyms do |t|
      t.string :name
      t.references :keyword
      t.boolean :approved

      t.timestamps
    end
    add_index :synonyms, :keyword_id
  end
end
