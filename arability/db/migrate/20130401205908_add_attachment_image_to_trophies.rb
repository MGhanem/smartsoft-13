class AddAttachmentImageToTrophies < ActiveRecord::Migration
  def self.up
    change_table :trophies do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :trophies, :image
  end
end
