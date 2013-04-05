class CreateGamerPrizes < ActiveRecord::Migration
  def up
    create_table :gamers_prizes, :id => false do |t|
      t.references :gamer
      t.references :prize
    end
  end

  def down
    drop_table :gamers_prizes
  end
end
