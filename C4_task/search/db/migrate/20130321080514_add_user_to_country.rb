class AddUserToCountry < ActiveRecord::Migration
  change_table :users do |t|
  	t.references :country
  end
end
