class Follow < ActiveRecord::Base
  attr_accessible :developer_id, :keyword_id
  # validates :developer_id, :keyword_id, :presence_of => true
  class << self
    
    # def follow(developer, keyword)
    #   follows = self.new(:developer_id => developer.id, :keyword_id => keyword.id)
    # end
  end
end
