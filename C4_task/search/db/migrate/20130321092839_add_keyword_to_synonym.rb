class AddKeywordToSynonym < ActiveRecord::Migration
  def change
  	change_table :synonyms do |syn|
  		syn.references :keywords
  	end
  end
end