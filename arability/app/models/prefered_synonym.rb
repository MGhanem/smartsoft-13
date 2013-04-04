class PreferedSynonym < ActiveRecord::Base
  attr_accessible :keyword_id, :synonym_id, :keyword_id
  belongs_to :project
  belongs_to :keyword
  belongs_to :synonym
  # attr_accessible :title, :body
  class << self
  	def add_keyword_and_synonym_to_project(synonym_id, keyword_id, project_id)
  		entry = Prefered_synonym.new
  		entry.project_id = project_id
  		entry.synonym_id = synonym_id
  		entry.keyword_id = keyword_id
  		entry.save
  	end
  end
end
