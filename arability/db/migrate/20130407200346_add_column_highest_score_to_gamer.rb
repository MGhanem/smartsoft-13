class AddColumnHighestScoreToGamer < ActiveRecord::Migration
  def change
  	add_column :gamer, :highest_score, :string
  end
end
