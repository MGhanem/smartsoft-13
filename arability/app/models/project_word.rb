class ProjectWord < ActiveRecord::Base
  belongs_to :project
  belongs_to :keyword
  belongs_to :synonym
  attr_accessible :project_id, :keyword_id, :synonym_id
  validates :project_id, :presence => true
  validates :keyword_id, :presence => true 
end
