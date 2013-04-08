class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.references :gamer
      t.string :provider
      t.string :gid
      t.string :token
      t.string :token_secret

      t.timestamps
    end
  end
end
