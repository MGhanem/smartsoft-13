class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
    	t.references :reported_word, :polymorphic => true
    	t.references :gamers
    	t.timestamps
    end
  end
end
