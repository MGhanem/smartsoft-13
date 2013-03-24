class CreateGamers < ActiveRecord::Migration
  def change
    create_table :gamers do |t|

      t.timestamps
    end
  end
end
