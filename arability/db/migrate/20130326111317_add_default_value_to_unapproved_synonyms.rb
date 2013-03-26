class AddDefaultValueToUnapprovedSynonyms < ActiveRecord::Migration
  def change
  	change_column_default :synonyms, :approved, false
  end
end
