class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :synonym
      t.references :gamer

      t.timestamps
    end
    add_index :votes, :synonym_id
    add_index :votes, :gamer_id
  end
end
