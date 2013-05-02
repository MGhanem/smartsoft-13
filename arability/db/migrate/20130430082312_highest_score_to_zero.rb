class HighestScoreToZero < ActiveRecord::Migration
  def change
  	change_column_default :gamers, :highest_score, 0
  end
end
