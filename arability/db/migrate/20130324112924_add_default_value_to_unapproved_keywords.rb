class AddDefaultValueToUnapprovedKeywords < ActiveRecord::Migration
  def change
    change_column_default :keywords, :approved, false
  end
end
