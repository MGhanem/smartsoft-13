class CreateDelevelopersKeywords < ActiveRecord::Migration
  def change
    create_table :developers_keywords do |t|
      t.references :developer
      t.references :keyword
    end
  end
end
