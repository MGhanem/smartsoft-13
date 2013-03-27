class ChangeSynonymToKeywordInSearches < ActiveRecord::Migration
  def change
  	rename_column :searches, :synonym_id, :keyword_id
  end
end
