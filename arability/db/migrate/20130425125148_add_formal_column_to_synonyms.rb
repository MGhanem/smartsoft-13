class AddFormalColumnToSynonyms < ActiveRecord::Migration
  def change
    add_column :synonyms, :is_formal, :boolean
  end
end
