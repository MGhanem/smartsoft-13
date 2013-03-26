class RemoveSynonymIdFromSearches < ActiveRecord::Migration
  def up
  	 remove_column :searches, :synonym_id
  end

  def down
  	add_column :searches, :keyword_id
  end
end
