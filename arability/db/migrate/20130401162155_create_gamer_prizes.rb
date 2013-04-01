class CreateGamerPrizes < ActiveRecord::Migration
  def up
    create_table :gamers_prizes, :id => false do |t|
      t.references :gamers
      t.references :prizes
    end
  end

  def down
    drop_table :gamers_prizes
  end
end
