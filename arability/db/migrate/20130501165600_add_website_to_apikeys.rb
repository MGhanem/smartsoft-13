class AddWebsiteToApikeys < ActiveRecord::Migration
  def change
    add_column :api_keys, :website, :string
  end
end
