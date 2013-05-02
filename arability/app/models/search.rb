class Search < ActiveRecord::Base
  attr_accessible :developer_id, :synonym_id
  belongs_to :keyword
  belongs_to :developer

end
