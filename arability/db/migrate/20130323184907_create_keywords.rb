class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
      t.string :name
      t.boolean :is_english
      t.boolean :approved

      t.timestamps
    end
  end
end
