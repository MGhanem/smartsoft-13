class CreateGamerTrophies < ActiveRecord::Migration
  def up
    create_table :gamers_trophies, :id => false do |t|
      t.references :gamer
      t.references :trophy
    end
  end

  def down
    drop_table :gamers_trophies
  end
end
