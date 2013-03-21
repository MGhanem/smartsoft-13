class VotesRelation < ActiveRecord::Migration

  def change
  	change_table  :votes do |v|
  		v.references :synonyms
  		v.references :users
  	end
  end

end
