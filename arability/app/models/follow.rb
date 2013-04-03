class Follow < ActiveRecord::Base
  attr_accessible :developer_id, :keyword_id
  validates :developer_id, :keyword_id, :presence_of => true
 end
