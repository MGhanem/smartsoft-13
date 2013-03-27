class CreateMySubscriptions < ActiveRecord::Migration
  def change
    create_table :my_subscriptions do |t|
      t.integer :word_search
      t.integer :word_follow
      t.integer :word_add
      t.refrences :developer

      t.timestamps
    end
  end
end
