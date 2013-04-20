class AddDefaultValueToApprovedInSynonymAndKeyword < ActiveRecord::Migration
  def change
  	change_column_default :synonyms, :approved, true
  	change_column_default :keywords, :approved, true
  end
end
