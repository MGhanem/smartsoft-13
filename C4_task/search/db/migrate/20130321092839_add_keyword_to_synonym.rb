class AddKeywordToSynonym < ActiveRecord::Migration
  def change
  	change_table :synonym do |syn|
  		syn.references :keyword
  end
end
