class AddDefaultValueToUnapprovedKeywords < ActiveRecord::Migration
  def change
    update_column :keywords,:approved,:default=>false
  end
end
